# Nix-based Dotfiles

This dotfiles configuration uses Nix and Home Manager for declarative, reproducible environment management.

## Quick Start (1-liner Installation)

### Prerequisites

1. Install Nix (if not already installed):
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. Enable flakes by creating `~/.config/nix/nix.conf`:
   ```
   experimental-features = nix-command flakes
   ```

### Install Dotfiles

Clone this repository and apply the configuration:

```bash
git clone https://github.com/atabee/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && \
nix run home-manager/master -- switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
```

The `--impure` flag allows the configuration to use your current `$USER` and `$HOME` environment variables, making it work on any machine without hardcoded usernames.

## Supported Platforms

- macOS (Intel): `x86_64-darwin`
- macOS (Apple Silicon): `aarch64-darwin`
- Linux (x86_64): `x86_64-linux`
- Linux (ARM64): `aarch64-linux`

## Updating Configuration

After making changes to the configuration:

```bash
cd ~/.dotfiles
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
```

Or create an alias:

```bash
alias hms='home-manager switch --flake ~/.dotfiles#$(uname -m)-$(uname -s | tr "[:upper:]" "[:lower:]") --impure'
```

## Updating Packages

Update flake inputs (nixpkgs, home-manager):

```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
```

## Rollback

Home Manager keeps generations of your configurations. To rollback:

```bash
# List generations
home-manager generations

# Activate a previous generation
/nix/store/XXXXX-home-manager-generation/activate
```

## Local Customization

### Git Configuration

Edit `git/.gitconfig.local` with your personal information:

```ini
[user]
    name = Your Name
    email = your.email@example.com

[credential]
    helper = osxkeychain  # or other credential helper
```

### Zsh Configuration

Create `~/.config/zsh/local.zsh` for machine-specific Zsh configuration:

```zsh
# Machine-specific environment variables
export SOME_LOCAL_VAR="value"

# Machine-specific aliases
alias local-command='...'
```

This file is sourced by Home Manager but not tracked in git, allowing for per-machine customization without modifying the repository.

## Structure

```
nix/
├── home.nix              # Main Home Manager configuration
├── packages.nix          # Package declarations
├── programs/             # Program-specific configurations
│   ├── fzf/
│   │   ├── default.nix   # fzf module
│   │   └── README.md
│   ├── git/
│   │   ├── default.nix   # Git module
│   │   ├── gitconfig.local.template
│   │   └── README.md
│   ├── ghostty/
│   │   ├── default.nix   # Ghostty module
│   │   ├── config        # Ghostty config file
│   │   └── README.md
│   └── zsh/
│       ├── default.nix   # Zsh module
│       ├── p10k.zsh      # Powerlevel10k theme
│       ├── local.zsh.template
│       ├── functions/    # Custom Zsh functions
│       └── README.md
├── modules/              # Custom modules
│   └── env-vars.nix      # Environment variables and tool initialization
└── platform/             # Platform-specific configurations
    ├── darwin.nix        # macOS-specific
    └── linux.nix         # Linux-specific
```

## New Packages

Recent additions to the package set:
- `aria2`: Multi-protocol download utility
- `gh`: GitHub CLI for repository and issue management
- `tree`: Directory tree visualization
- `jq`: Command-line JSON processor

## Notes

- **No hardcoded usernames**: The configuration dynamically uses `$USER` and `$HOME`
- **No sensitive data**: Git user information and credentials are kept in local files
- **Cross-platform**: Same configuration works on macOS and Linux
- **Program-centric structure**: Each program has its own folder with module, configs, and docs
