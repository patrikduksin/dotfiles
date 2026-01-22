# Patrik's Dotfiles

macOS system configuration using Nix Darwin and Home Manager.

## Fresh Mac Setup

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone this repo

```bash
git clone https://github.com/patrikduksin/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Build and apply

```bash
nix run nix-darwin -- switch --flake .
```

### 4. Subsequent updates

```bash
darwin-rebuild switch --flake ~/dotfiles
```

## What's Included

### Homebrew Packages

**CLI Tools:** bat, eza, fd, fzf, ripgrep, zoxide, jq, yazi, direnv, mise, fish, starship, ffmpeg, imagemagick, cmake, cocoapods, fastlane, watchman, mas

**Apps:**
- Essential: 1Password, Aerospace, Raycast, Ghostty, Cursor, Helium
- Communication: Slack, Telegram, WhatsApp, Zoom, Discord, Teams, Loom
- Development: Figma, Insomnia, ngrok, mitmproxy, Xcodes, OpenMTP
- Utilities: AlDente, HiddenBar, OBS, Macs Fan Control, Contexts, IINA
- Apps: Spotify, Notion, Notion Calendar, ChatGPT, SuperWhisper

**Mac App Store:** Infuse

### Configuration Files

- Fish shell config
- Starship prompt (Nerd Font symbols)
- Git config (1Password SSH signing)
- mise version manager
- Aerospace window manager

### macOS Settings

- Dock: autohide, no recent apps
- Finder: show all extensions, path bar, list view
- Keyboard: fast key repeat
- Trackpad: tap to click, three finger drag
- Dark mode enabled
- Touch ID for sudo

## Manual Steps

### 1. Revoke exposed GitHub token

The old fish config had an exposed token. Revoke it at:
https://github.com/settings/tokens

### 2. Install Cursor extensions

Open Cursor and install:
```
biomejs.biome
dbaeumer.vscode-eslint
dooez.alt-catppuccin-vsc
esbenp.prettier-vscode
expo.vscode-expo-theme
expo.vscode-expo-tools
redhat.vscode-yaml
rvest.vs-code-prettier-eslint
vscodevim.vim
yoavbls.pretty-ts-errors
```

### 3. Install Claude Code

```bash
bun install -g @anthropic-ai/claude-code
```

### 4. Sign in to apps

- 1Password
- Raycast
- Slack, Telegram, WhatsApp, Discord, Teams
- Spotify
- Notion
- Figma

### 5. Configure 1Password SSH agent

Enable SSH agent in 1Password settings for git signing to work.

## Directory Structure

```
~/dotfiles/
├── flake.nix                 # Entry point
├── flake.lock
├── darwin/
│   └── default.nix           # nix-darwin: brew, system settings
├── home/
│   └── default.nix           # home-manager: dotfiles, programs
└── config/
    ├── fish/config.fish
    ├── starship.toml
    ├── mise/config.toml
    └── aerospace/aerospace.toml
```

## Updating

```bash
# Update flake inputs
cd ~/dotfiles
nix flake update

# Apply changes
darwin-rebuild switch --flake .
```
