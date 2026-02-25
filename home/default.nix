{ config, pkgs, username, ... }:

{
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # XDG directories
  xdg.enable = true;

  # Symlink config files
  xdg.configFile = {
    "fish/config.fish".source = ../config/fish/config.fish;
    "fish/conf.d/op_auto_env.fish".source = ../config/fish/conf.d/op_auto_env.fish;
    "starship.toml".source = ../config/starship.toml;
    "mise/config.toml".source = ../config/mise/config.toml;
    "aerospace/aerospace.toml".source = ../config/aerospace/aerospace.toml;
    "ghostty/config".source = ../config/ghostty/config;
  };

  # Claude Code global settings
  home.file = {
    ".claude/settings.json".source = ../config/claude/settings.json;
    ".zshenv".source = ../config/zsh/.zshenv;
    ".zshrc".source = ../config/zsh/.zshrc;
  };

  # Git configuration
  programs.git = {
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0iOIEYecJt7by7sMJ6IuOOFyh0e39LojiY7QdeNGo+";
      signByDefault = true;
    };

    settings = {
      user.name = "Patrik Duksin";
      user.email = "patrikduksin@gmail.com";
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # Cursor extensions (managed manually - just documenting here)
  # Extensions to install via Cursor:
  # - biomejs.biome
  # - dbaeumer.vscode-eslint
  # - dooez.alt-catppuccin-vsc
  # - esbenp.prettier-vscode
  # - expo.vscode-expo-theme
  # - expo.vscode-expo-tools
  # - redhat.vscode-yaml
  # - rvest.vs-code-prettier-eslint
  # - vscodevim.vim
  # - yoavbls.pretty-ts-errors
}
