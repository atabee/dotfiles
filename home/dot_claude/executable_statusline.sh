#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract all values in a single jq call (pipe-delimited to handle spaces in names)
IFS='|' read -r MODEL_DISPLAY CURRENT_DIR CTX_PCT FIVE_PCT WEEK_PCT <<< "$(echo "$input" | jq -r '[
  .model.display_name,
  .workspace.current_dir,
  (.context_window.used_percentage | tostring),
  (.rate_limits.five_hour.used_percentage | tostring),
  (.rate_limits.seven_day.used_percentage | tostring)
] | join("|")')"

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" \033[2m│\033[0m 🌿 $BRANCH"
    fi
fi

# Build usage bars with awk
USAGE_BARS=$(awk -v ctx="$CTX_PCT" -v five="$FIVE_PCT" -v week="$WEEK_PCT" 'BEGIN {
    # Braille characters: 8 levels from empty to full
    split(" ,⣀,⣄,⣤,⣦,⣶,⣷,⣿", br, ",")
    width = 8
    sep = ""
    out = ""

    n = split("ctx,5h,7d", labels, ",")
    split(ctx "," five "," week, vals, ",")

    for (i = 1; i <= n; i++) {
        v = vals[i]
        if (v == "null" || v == "") {
            entry = sprintf("\033[2m%s\033[0m \033[2m   --   \033[0m  --", labels[i])
            out = out sep entry
            sep = " \033[2m│\033[0m "
            continue
        }

        pct = v + 0
        if (pct < 0) pct = 0
        if (pct > 100) pct = 100

        # Gradient color: green at low, red at high
        if (pct < 50) {
            r = int(pct * 5.1)
            g = 200
            b = 80
        } else {
            r = 255
            g = int(200 - (pct - 50) * 4)
            b = 60
        }
        color = sprintf("\033[38;2;%d;%d;%dm", r, g, b)

        # Build braille bar
        filled = (pct / 100) * width
        bar = ""
        for (j = 0; j < width; j++) {
            if (j + 1 <= int(filled)) {
                bar = bar br[8]  # full block
            } else if (j < filled) {
                frac = filled - j
                idx = int(frac * 7) + 1
                if (idx < 1) idx = 1
                if (idx > 8) idx = 8
                bar = bar br[idx]
            } else {
                bar = bar " "
            }
        }

        # Format: dim_label + color_bar + pct
        entry = sprintf("\033[2m%s\033[0m %s%s\033[0m %3d%%", labels[i], color, bar, pct)
        out = out sep entry
        sep = " \033[2m│\033[0m "
    }
    printf "%s", out
}'
)

# Compose final output
BASE="[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}${GIT_BRANCH}"
if [ -n "$USAGE_BARS" ]; then
    printf '%b \033[2m│\033[0m %b\n' "$BASE" "$USAGE_BARS"
else
    printf '%b\n' "$BASE"
fi
