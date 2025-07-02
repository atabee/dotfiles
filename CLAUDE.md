# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS/Linux development environment setup. It uses a modular structure with shell scripts to deploy configuration files and install development tools.

## Key Commands

### Installation and Setup

```bash
# Initial installation (from web)
curl -L raw.githubusercontent.com/atabichi/dotfiles/main/install | bash

# Manual installation (if repository already exists)
./install

# Deploy configuration files only
source etc/deploy.sh

# Install tools only  
source etc/init.sh
```

### Package Management

```bash
# Install all packages via Homebrew
brew bundle --file=brew/Brewfile

# Update Brewfile with currently installed packages
brew bundle dump --file=brew/Brewfile --force
```

## Architecture

### Core Structure

- **`install`**: Main installation script that orchestrates the entire setup
- **`etc/`**: Core shell scripts for environment setup
  - `env.sh`: Loads utility functions and environment
  - `init.sh`: Installs development tools (fzf, go, ghq, fonts)
  - `deploy.sh`: Creates symlinks for configuration files
  - `install_utils.sh`: Platform-specific installation functions
  - `log_utils.sh`: Logging and output utilities

### Configuration Modules

Each directory represents a tool/application configuration:

- **`zsh/`**: Zsh shell configuration with Prezto framework
- **`git/`**: Git configuration files
- **`vim/`**: Vim editor configuration
- **`tmux/`**: Terminal multiplexer configuration
- **`brew/`**: Homebrew package definitions (Brewfile)
- **`ghostty/`**: Ghostty terminal configuration
- **`iterm2/`**: iTerm2 terminal configuration
- **`rye/`**: Python package manager configuration

### Dependencies Management

- Uses git submodules for external dependencies (Prezto, fzf, fonts)
- Homebrew Brewfile manages system packages and applications
- Platform detection supports both macOS and Linux

### Deployment Strategy

- Creates backup copies of existing configuration files with timestamps
- Uses symbolic links to maintain connection with repository
- Supports incremental updates by re-running deployment scripts

## Development Workflow

### Adding New Configurations

1. Create new directory for the tool (e.g., `newtool/`)
2. Add configuration files to the directory
3. Update `etc/deploy.sh` to create symlinks
4. If the tool requires installation, add to `etc/init.sh`

### Modifying Existing Configurations

- Edit files directly in the repository
- Changes are reflected immediately due to symlink structure
- No redeployment needed for configuration changes

### Package Management

- Add new packages to `brew/Brewfile`
- Run `brew bundle` to install new packages
- Commit updated Brewfile to repository
