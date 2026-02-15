{ pkgs, username, ... }:

{
  # Nix configuration
  # Disable nix-darwin's Nix management since we're using Determinate
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (minimal - prefer homebrew for GUI apps)
  environment.systemPackages = with pkgs; [
    git
    vim
    tmux
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # Remove unlisted packages
      upgrade = true;
    };

    # Taps
    taps = [
      "nikitabobko/tap"  # For aerospace
    ];

    # CLI tools
    brews = [
      "aria2"
      "bat"
      "eza"
      "fd"
      "fzf"
      "ripgrep"
      "zoxide"
      "jq"
      "yazi"
      "direnv"
      "mise"
      "fish"
      "starship"
      "ffmpeg"
      "imagemagick"
      "cmake"
      "cocoapods"
      "fastlane"
      "watchman"
      "mas"
      "gh"
      "anomalyco/tap/opencode"
    ];

    # GUI applications
    casks = [
      # Essential
      "1password"
      "1password-cli"
      "nikitabobko/tap/aerospace"
      "raycast"
      "ghostty"
      "cursor"
      "helium-browser"

      # Communication
      "slack@beta"
      "telegram"
      "whatsapp"
      "zoom"
      "discord"
      "microsoft-teams"
      "loom"

      # Development
      "figma@beta"
      "insomnia"
      "ngrok"
      "mitmproxy"
      "xcodes"
      "openmtp"

      # Utilities
      "aldente"
      "hiddenbar"
      "obs"
      "macs-fan-control"
      "contexts"
      "iina"
      "wispr-flow"

      # Apps
      "spotify"
      "notion"
      "notion-calendar"
      "chatgpt"
      "codex"
      "codex-app"
    ];

    # Mac App Store apps
    masApps = {
      "Infuse" = 1136220934;
    };
  };

  # macOS system settings
  system = {
    # Used for backwards compatibility
    stateVersion = 5;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        magnification = true;
        largesize = 88;
        minimize-to-application = true;
        mru-spaces = false;
        show-recents = false;
        tilesize = 59;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";  # List view
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      # Global settings
      NSGlobalDomain = {
        # Keyboard - fastest repeat rate and shortest delay
        KeyRepeat = 1;
        InitialKeyRepeat = 10;
        ApplePressAndHoldEnabled = false;

        # Mouse/Trackpad
        "com.apple.mouse.tapBehavior" = 1;  # Tap to click

        # Interface
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      # Menu bar clock
      menuExtraClock = {
        Show24Hour = true;
        ShowSeconds = false;
      };

      # Disable Spotlight keyboard shortcuts (Cmd+Space)
      CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # 64 = Show Spotlight search (Cmd+Space)
            "64" = {
              enabled = false;
            };
            # 65 = Show Finder search window (Cmd+Option+Space)
            "65" = {
              enabled = false;
            };
          };
        };
        # Raycast global hotkey (Cmd+Space, keycode 49 = Space)
        "com.raycast.macos" = {
          raycastGlobalHotkey = "Command-49";
        };
        # Input sources (keyboards)
        "com.apple.HIToolbox" = {
          AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.US";
          AppleEnabledInputSources = [
            { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }
            { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = "RussianWin"; }
          ];
          AppleSelectedInputSources = [
            { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }
          ];
        };
        # Use Caps Lock to switch input source
        NSGlobalDomain = {
          TISRomanSwitchState = 1;
        };
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = false;
      # Remap F4/F5/F6 to old MacBook Pro behavior
      userKeyMapping = [
        # F4 (Spotlight) → Launchpad (0xC00000221 → 0xC000002A2)
        {
          HIDKeyboardModifierMappingSrc = 51539608097;
          HIDKeyboardModifierMappingDst = 51539608226;
        }
        # F5 (Dictation) → Keyboard Brightness Down (0xC000000CF → 0xFF00000009)
        {
          HIDKeyboardModifierMappingSrc = 51539607759;
          HIDKeyboardModifierMappingDst = 1095216660489;
        }
        # F6 (Do Not Disturb) → Keyboard Brightness Up (0x10000009B → 0xFF00000008)
        {
          HIDKeyboardModifierMappingSrc = 4294967451;
          HIDKeyboardModifierMappingDst = 1095216660488;
        }
      ];
    };
  };

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Primary user for user-specific settings
  system.primaryUser = username;

  # Set fish as the default shell
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  # Fonts (nerd-fonts are now individual packages)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
