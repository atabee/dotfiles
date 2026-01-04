# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS/Linux development environment setup. It uses Nix with Home Manager for declarative, reproducible configuration management.

## Key Commands

### Installation and Setup

```bash
# 1. Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2. Enable Flakes feature
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# 3. Clone and apply dotfiles
git clone https://github.com/atabee/dotfiles ~/.dotfiles
cd ~/.dotfiles
nix run home-manager/master -- switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure

# 4. Create local configuration files
cp config/git/.gitconfig.local.template git/.gitconfig.local
# Edit with your Git user information
vim git/.gitconfig.local
```

### Package Management

```bash
# Add packages to nix/packages.nix, then apply changes
home-manager switch --flake ~/.dotfiles#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]') --impure

# Update all packages
cd ~/.dotfiles
nix flake update
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure

# Rollback to previous generation
home-manager generations
/nix/store/XXXXX-home-manager-generation/activate
```

## Architecture

### Core Structure

- **`flake.nix`**: Nix Flakes entry point with multi-platform support
- **`nix/home.nix`**: Main Home Manager configuration
- **`nix/packages.nix`**: Declarative package definitions
- **`nix/programs/`**: Program-specific configurations (zsh, git, fzf, ghostty)
- **`nix/modules/`**: Custom modules (environment variables, tool integrations)
- **`nix/platform/`**: Platform-specific settings (darwin, linux)

### Configuration Files

Configuration files are organized by purpose:

- **`config/zsh/`**: Zsh configuration files
  - `.p10k.zsh`: Powerlevel10k theme configuration
  - `functions/`: Custom Zsh functions
  - `local.zsh.template`: Template for machine-specific settings
- **`config/git/`**: Git configuration templates
  - `.gitconfig.local.template`: Template for user-specific Git settings
- **`ghostty/`**: Ghostty terminal configuration
- **`iterm2/`**: iTerm2 terminal configuration

### Dependencies Management

- All packages managed declaratively through Nix
- No git submodules (removed in favor of Nix packages)
- Platform detection handled at runtime in shell scripts
- Dynamic user configuration using `builtins.getEnv` with `--impure` flag

### Deployment Strategy

- Home Manager manages all dotfiles declaratively
- Configuration files deployed via `home.file` in `nix/home.nix`
- Sensitive data (Git user info) kept in local files not tracked by git
- Supports multiple machines without hardcoded usernames

## Development Workflow

### Adding New Configurations

1. Add configuration files to appropriate directory (e.g., `config/newtool/`)
2. Create Nix module in `nix/programs/newtool.nix`
3. Import module in `nix/home.nix`
4. Apply changes: `home-manager switch --flake ~/.dotfiles#... --impure`

### Modifying Existing Configurations

**For Nix-managed settings** (`nix/programs/*.nix`):
1. Edit the `.nix` file
2. Apply changes: `home-manager switch --flake ~/.dotfiles#... --impure`

**For native config files** (`config/`, `ghostty/`, etc.):
- Edit files directly in the repository
- Changes are reflected immediately (Home Manager creates symlinks)

### Package Management

1. Edit `nix/packages.nix` to add/remove packages
2. Apply changes: `home-manager switch --flake ~/.dotfiles#... --impure`
3. Commit changes to repository

### Local Customization

**Machine-specific settings** (not tracked in git):
- `~/.dotfiles/git/.gitconfig.local`: Git user information
- `~/.config/zsh/local.zsh`: Machine-specific Zsh settings
