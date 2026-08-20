{ config, pkgs, lib, inputs, username, ... }:

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

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Avoid local Home Manager option-doc generation during system rebuilds.
  manual.manpages.enable = false;

  # XDG directories
  xdg.enable = true;

  # Symlink config files
  xdg.configFile = {
    "mise/config.toml".source = ../config/mise/config.toml;
    "aerospace/aerospace.toml".source = ../config/aerospace/aerospace.toml;
    "ghostty/config".source = ../config/ghostty/config;
    "herdr/config.toml".source = ../config/herdr/config.toml;
  };

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/settings.json";
    ".pi/web-search.json".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/web-search.json";
    ".pi/agent/extensions/onepassword-environment".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/config/pi/extensions/onepassword-environment";
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

  # Prompt and shell integrations
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

  # Make Homebrew's Docker CLI plugins discoverable by `docker`.
  home.activation.dockerCliPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOCKER_CONFIG_DIR="$HOME/.docker"
    DOCKER_PLUGIN_DIR="$DOCKER_CONFIG_DIR/cli-plugins"
    BREW_BIN="/opt/homebrew/bin/brew"

    if [ ! -x "$BREW_BIN" ]; then
      BREW_BIN="$(command -v brew || true)"
    fi

    if [ -n "$BREW_BIN" ] && [ -x "$BREW_BIN" ]; then
      mkdir -p "$DOCKER_PLUGIN_DIR"

      for plugin in docker-compose docker-buildx; do
        plugin_bin="$("$BREW_BIN" --prefix)/opt/$plugin/bin/$plugin"
        if [ -x "$plugin_bin" ]; then
          ln -sfn "$plugin_bin" "$DOCKER_PLUGIN_DIR/$plugin"
        fi
      done
    fi
  '';

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
