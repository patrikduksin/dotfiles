{ config, pkgs, lib, inputs, username, ... }:

let
  peonPingPackage = inputs.peon-ping.packages.${pkgs.system}.default;
  homeDir = config.home.homeDirectory;

  peonHookCommand = "${homeDir}/.openpeon/peon.sh";
  peonUseHookCommand = "${homeDir}/.openpeon/scripts/hook-handle-use.sh";
  peonRenameHookCommand = "${homeDir}/.openpeon/scripts/hook-handle-rename.sh";

  peonSyncHook = {
    type = "command";
    command = peonHookCommand;
    timeout = 10;
  };

  peonAsyncHook = peonSyncHook // {
    async = true;
  };

  claudeSettings =
    (builtins.fromJSON (builtins.readFile ../config/claude/settings.json))
    // {
      hooks = {
        SessionStart = [
          { matcher = ""; hooks = [ peonSyncHook ]; }
        ];
        SessionEnd = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
        SubagentStart = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
        UserPromptSubmit = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = peonUseHookCommand;
                timeout = 5;
              }
              {
                type = "command";
                command = peonRenameHookCommand;
                timeout = 5;
              }
            ];
          }
        ];
        Stop = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
        Notification = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
        PermissionRequest = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
        PostToolUseFailure = [
          { matcher = "Bash"; hooks = [ peonAsyncHook ]; }
        ];
        PreCompact = [
          { matcher = ""; hooks = [ peonAsyncHook ]; }
        ];
      };
    };
in
{
  imports = [ inputs.peon-ping.homeManagerModules.default ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
  };

  home.packages = [ peonPingPackage ];

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
    ".claude/settings.json".text = builtins.toJSON claudeSettings;
    ".zshenv".source = ../config/zsh/.zshenv;
    ".zshrc".source = ../config/zsh/.zshrc;
  };

  programs.peon-ping = {
    enable = true;
    package = peonPingPackage;
    installPacks = [
      "glados"
      "peasant"
      "peon"
      "peon_ru"
      "sc_battlecruiser"
      "sc_kerrigan"
    ];
  };

  home.sessionVariables.CLAUDE_PEON_DIR = "${homeDir}/.openpeon";

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

  # Install OpenClaw once during Home Manager activation
  home.activation.openclawSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v openclaw >/dev/null 2>&1; then
      echo "Installing OpenClaw..."
      ${pkgs.curl}/bin/curl -fsSL https://openclaw.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
  '';

  # Keep mise tools on the newest available versions from global config.
  home.activation.miseSyncLatest = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    MISE_BIN="/opt/homebrew/bin/mise"
    if [ ! -x "$MISE_BIN" ]; then
      MISE_BIN="$(command -v mise || true)"
    fi

    if [ -n "$MISE_BIN" ] && [ -x "$MISE_BIN" ]; then
      "$MISE_BIN" trust "$HOME/.config/mise/config.toml" >/dev/null 2>&1 || true

      cd "$HOME"
      "$MISE_BIN" install --yes >/dev/null 2>&1 || true
      "$MISE_BIN" upgrade --yes \
        bun \
        node \
        npm:prettier \
        npm:@openai/codex \
        npm:eas-cli \
        pnpm \
        rust \
        uv >/dev/null 2>&1 || true

      # Prevent node global npm installs from shadowing dedicated npm:* tools.
      for node_npm in "$HOME"/.local/share/mise/installs/node/*/bin/npm; do
        [ -x "$node_npm" ] || continue
        "$node_npm" uninstall -g @openai/codex eas-cli >/dev/null 2>&1 || true
      done

      "$MISE_BIN" reshim >/dev/null 2>&1 || true
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
