{ pkgs, username, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (minimal - prefer homebrew for GUI apps)
  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # Remove unlisted packages
      upgrade = true;
    };

    # CLI tools
    brews = [
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
    ];

    # GUI applications
    casks = [
      # Essential
      "1password"
      "1password-cli"
      "aerospace"
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

      # Apps
      "spotify"
      "notion"
      "notion-calendar"
      "chatgpt"
      "superwhisper"
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
        minimize-to-application = true;
        mru-spaces = false;
        show-recents = false;
        tilesize = 48;
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
        # Keyboard
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
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
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = false;
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
