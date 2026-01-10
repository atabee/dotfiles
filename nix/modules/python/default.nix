{ pkgs, lib, ... }:

{
  # Python development environment
  home.packages = with pkgs; [
    # Python package and project manager
    uv # Fast Python package installer and resolver
  ];

  # Environment variables for Python development
  home.sessionVariables = {
    # Use uv for Python project management
    UV_PYTHON_PREFERENCE = "only-managed";
  };

  # Shell integration
  programs.zsh.initContent = lib.mkAfter ''
    # uv shell completion
    if command -v uv &> /dev/null; then
      eval "$(uv generate-shell-completion zsh)"
    fi

    # Add local bin to PATH (for uv-installed tools)
    export PATH="$HOME/.local/bin:$PATH"
  '';
}
