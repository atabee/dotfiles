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
nix run home-manager/master -- switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
```

Home Manager automatically detects your username and home directory, so the same configuration works on any machine without hardcoded values.

## Supported Platforms

- macOS (Intel): `x86_64-darwin`
- macOS (Apple Silicon): `aarch64-darwin`
- Linux (x86_64): `x86_64-linux`
- Linux (ARM64): `aarch64-linux`

## Updating Configuration

After making changes to the configuration:

```bash
cd ~/.dotfiles
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
```

Or create an alias:

```bash
alias hms='home-manager switch --flake ~/.dotfiles#$(uname -m)-$(uname -s | tr "[:upper:]" "[:lower:]")'
```

## Updating Packages

Update flake inputs (nixpkgs, home-manager):

```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
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
├── home.nix           # Main Home Manager configuration
├── packages.nix       # Package declarations
├── programs/          # Program-specific configurations
│   ├── zsh.nix
│   ├── fzf.nix
│   ├── git.nix
│   └── ghostty.nix
├── modules/           # Custom modules
│   └── env-vars.nix
└── platform/          # Platform-specific configurations
    ├── darwin.nix
    └── linux.nix
```

## Notes

- **No hardcoded usernames**: The configuration dynamically uses `$USER` and `$HOME`
- **No sensitive data**: Git user information and credentials are kept in local files
- **Cross-platform**: Same configuration works on macOS and Linux
