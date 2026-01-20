# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Cross-platform dotfiles repository using Nix Flakes, Home Manager, and nix-darwin for declarative system and user environment management across macOS (Apple Silicon) and Linux (x86_64/ARM64/WSL2).

## Key Commands

### Apply Configuration Changes

**macOS:**

```bash
cd ~/.dotfiles
sudo darwin-rebuild switch --flake '.#aarch64-darwin' --impure
```

**Linux:**

```bash
cd ~/.dotfiles
home-manager switch --flake ".#$(uname -m)-linux" --impure
```

### Update Dependencies

```bash
cd ~/.dotfiles
nix flake update  # Updates flake.lock
# Then apply changes with darwin-rebuild or home-manager switch
```

### Rollback

```bash
home-manager generations
/nix/store/XXXXX-home-manager-generation/activate
```

## Architecture

### Flake Structure

- **Entry point:** `flake.nix` defines configurations for all supported platforms
- **User config:** `nix/home-manager.nix` aggregates all modules (works on all platforms)
- **System config:** nix-darwin configuration embedded in `flake.nix` (macOS only)

### Dynamic User Resolution

The configuration uses environment variables instead of hardcoded usernames:

- `home.username = builtins.getEnv "USER"`
- `home.homeDirectory = builtins.getEnv "HOME"`
- nix-darwin uses `SUDO_USER` fallback for system-level operations

**Critical:** Always use `--impure` flag when running build commands to access environment variables.

### Module System

All modules are in `nix/modules/` with consistent structure:

- `default.nix`: Package installation and program configuration
- Optional: Templates, config files, custom scripts
- Platform conditionals use `lib.mkIf pkgs.stdenv.isDarwin`

Active modules (imported in `nix/home-manager.nix`):

- **Platform:** `platform/darwin.nix` (macOS-specific)
- **Core:** zsh, fzf, git, ghostty, direnv, utilities
- **Languages:** go, node, python, ruby, rustup
- **Mobile:** mobile-dev (Flutter/Android)
- **Homebrew:** `modules/homebrew` (managed via nix-darwin)

### Platform-Specific Behavior

**macOS (via nix-darwin):**

- System-level configuration + Homebrew + Home Manager in one command
- Homebrew managed declaratively via nix-homebrew
- Uses `darwin-rebuild switch` command
- Manages `/etc` shell files (bashrc, zshrc, zshenv)

**Linux (Home Manager only):**

- User environment only, no system-level management
- Uses `home-manager switch` command
- Architecture detection via `$(uname -m)-linux`

## Important Configuration Details

### User Customization Files

These files are NOT tracked by git and must be created manually:

- `~/.config/git/.gitconfig.local` - Git user credentials (template provided)
- `~/.config/zsh/local.zsh` - Machine-specific Zsh config (template provided)

Templates are deployed to `.template` suffix and users must copy/edit them.

### Determinate Nix

This repository is configured for Determinate Nix:

- `nix.enable = false` in nix-darwin config (flake.nix:99)
- Determinate Nix uses its own daemon that conflicts with nix-darwin's Nix management
- Flakes and experimental features are pre-enabled

### Language Environments

**Environment variable patterns:**

- Go: `GOPATH=~/go`, `GOBIN=~/go/bin`
- Node: npm global prefix at `~/.npm-global`
- Python: Uses `uv` package manager, `UV_PYTHON_PREFERENCE=only-managed`
- Ruby: Gems at `~/.gem`
- Rust: `RUSTUP_HOME` and `CARGO_HOME` in XDG data directories
- Mobile: `ANDROID_HOME=~/Library/Android/sdk` (macOS), Flutter via FVM

**Project isolation:** direnv with nix-direnv integration for per-project environments

### File Deployment

Home Manager's `home.file` (in `nix/home-manager.nix:58-68`) deploys:

- `p10k.zsh`: Powerlevel10k theme configuration
- `functions/`: Custom Zsh functions
- `.template` files for user customization

Git configuration templates are deployed via `modules/git/default.nix`.

## Common Development Workflows

### Adding Packages

**CLI utilities:** Edit `nix/modules/utilities/default.nix`, add to `home.packages`

**Homebrew (macOS):** Edit `nix/modules/homebrew/default.nix`:

- `brews` list for CLI tools
- `casks` list for GUI applications

**Language-specific:** Edit or create module in `nix/modules/`

### Creating New Modules

1. Create `nix/modules/<name>/default.nix`
2. Add import to `nix/home-manager.nix`
3. Optional: Add README.md following existing module patterns
4. Use platform conditionals if needed: `lib.mkIf pkgs.stdenv.isDarwin { ... }`

### Module README Pattern

Each module should have `README.md` with:

- Brief description in heading
- **ファイル** section listing files
- **機能** section describing features
- **使い方** or setup instructions (if applicable)
- **パッケージ** section listing installed packages

### Shell Integration

**Zsh customization:**

- Shell aliases: `programs.zsh.shellAliases` in modules/zsh/default.nix
- Custom functions: Place in `modules/zsh/functions/` directory
- Init extra: `programs.zsh.initExtra` for shell code

**Common integrations:**

- direnv: Auto-activates project environments
- fzf: Ctrl+R (history), Ctrl+T (files), Ctrl+] (ghq repos)
- ghq: Repository management with roots at `~/go/src` and `~/src`

## Troubleshooting

### "primary user does not exist" Error

The `--impure` flag is required to read environment variables like `$USER` and `$SUDO_USER`.

### "Unexpected files in /etc" (macOS first install)

Backup existing files before first nix-darwin installation:

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
```

### darwin-rebuild Command Not Found

Use the full nix-darwin bootstrap command first:

```bash
sudo nix run nix-darwin -- switch --flake '.#aarch64-darwin' --impure
```

### Configuration Not Applied

On macOS, ensure you're using `darwin-rebuild` (not `home-manager switch`).
This applies all configurations including Homebrew and system settings.

## Repository Conventions

- **Language:** Documentation and comments in Japanese
- **State version:** `24.05` (set once, do not change)
- **Unfree packages:** Allowed via `config.allowUnfree = true`
- **System state version:** `6` for nix-darwin (flake.nix:86)
- **Homebrew:** Auto-update and auto-upgrade enabled, cleanup="zap"
