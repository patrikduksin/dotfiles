{ config, username, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/.local/share/mise/shims"
      "$HOME/.local/bin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
  };

  manual.manpages.enable = false;

  xdg.configFile = {
    "mise/config.toml".source = ./config/mise.toml;
    "aerospace/aerospace.toml".source = ./config/aerospace.toml;
    "ghostty/config".source = ./config/ghostty.conf;
    "herdr/config.toml".source = ./config/herdr.toml;
  };

  home.file = {
    ".docker/cli-plugins/docker-buildx".source = config.lib.file.mkOutOfStoreSymlink "/opt/homebrew/opt/docker-buildx/bin/docker-buildx";
    ".docker/cli-plugins/docker-compose".source = config.lib.file.mkOutOfStoreSymlink "/opt/homebrew/opt/docker-compose/bin/docker-compose";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/settings.json";
    ".pi/web-search.json".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/web-search.json";
    ".pi/agent/extensions/onepassword-environment".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/onepassword-environment";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Patrik Duksin";
        email = "patrikduksin@gmail.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0iOIEYecJt7by7sMJ6IuOOFyh0e39LojiY7QdeNGo+";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      credential = {
        "https://github.com".helper = [ "" "!gh auth git-credential" ];
        "https://gist.github.com".helper = [ "" "!gh auth git-credential" ];
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if command -q mise
        mise activate fish | source
      end
    '';
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      cat = "bat";
      find = "fd";
      docker-start = "colima start";
      docker-stop = "colima stop";
    };
    functions.rebuild = {
      description = "Build and activate the nix-darwin configuration";
      body = ''
        nix build "$HOME/dotfiles#darwinConfigurations.Patriks-MacBook-Pro.system" --out-link "$HOME/dotfiles/result"; or return
        sudo "$HOME/dotfiles/result/activate"
      '';
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

}
