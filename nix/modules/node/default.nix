{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    nodejs_24 # Node.js LTS
  ];

  # Note: claude-code is not available in nixpkgs
  # Install manually with: npm install -g @anthropic-ai/claude-code

  home.sessionVariables = {
    # Configure npm global prefix
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
}
