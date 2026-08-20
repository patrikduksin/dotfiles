# Patrik's Dotfiles

Declarative macOS workstation setup powered by nix-darwin and Home Manager. mise manages global language runtimes and developer tools within the Nix-managed system.

## Fresh Mac Setup

```bash
git clone https://github.com/patrikduksin/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix build .#darwinConfigurations.Patriks-MacBook-Pro.system --out-link result && sudo ./result/activate
mise install
bun install --cwd config/pi/onepassword-environment --frozen-lockfile
```

This assumes Homebrew and Determinate Nix are already installed.

## Everyday Commands

```bash
# Reapply the desired machine state (from ~/dotfiles)
nix build .#darwinConfigurations.Patriks-MacBook-Pro.system --out-link result && sudo ./result/activate

# Update flake inputs, then reapply
cd ~/dotfiles
nix flake update
nix build .#darwinConfigurations.Patriks-MacBook-Pro.system --out-link result && sudo ./result/activate

# Update mise-managed developer tools
mise upgrade
```

## What's Included

### Packages and applications

- nix-darwin manages Homebrew CLI tools, GUI applications, fonts, and Infuse.
- Homebrew CLI tools include Docker with Colima, mise, Herdr, ncspot, media tools, and iOS development tools.
- Applications include 1Password, AeroSpace, Raycast, Ghostty, Cursor, Helium, communication apps, Figma, ChatGPT, Korimako, and the configured utility and productivity apps.
- mise manages Bun, Node.js, pnpm, Rust, uv, Prettier, Codex, Claude Code, OpenCode, eas-cli, agent-browser, and pi-coding-agent.

### Dotfiles

Home Manager links and configures:

- Fish and Zsh
- Git with 1Password SSH signing and GitHub CLI credentials
- Starship, zoxide, fzf, and direnv
- mise
- AeroSpace, Ghostty, and Herdr
- Pi coding agent settings, packages, web-search configuration, and 1Password Environment credential loading

### macOS configuration

- Dock, Finder, keyboard, trackpad, menu-bar clock, and dark mode defaults
- Raycast on Command-Space with Spotlight shortcuts disabled
- U.S. and RussianWin input sources
- F4/F5/F6 hardware-key remapping
- Touch ID for `sudo`
- Docker Compose and buildx plugin discovery for the Homebrew Docker CLI

## Pi Web Credentials

Create a 1Password Environment containing `EXA_API_KEY`, `TAVILY_API_KEY`, and `FIRECRAWL_API_KEY`. Copy its Environment ID into `config/pi/onepassword-environment/config.json`.

On each new Mac, open 1Password, go to **Settings → Developer**, and enable **Integrate with other apps** under the SDK integration section. Pi loads the Environment on startup and `/reload`.

## Manual Steps

- Sign in to 1Password, Raycast, communication apps, Spotify, Notion, Figma, and other account-backed applications.
- Enable the 1Password SSH agent so Git signing works.
- Grant required macOS privacy permissions and authenticate the Apple Account.
- Install the Cursor extensions documented in `home.nix`.
- Confirm the GitHub token exposed by an older Fish configuration remains revoked.

## Repository Layout

```text
~/dotfiles/
├── flake.nix                 # Nix flake entry point
├── flake.lock
├── darwin.nix                # nix-darwin system and Homebrew state
├── home.nix                  # Home Manager programs and dotfiles
├── config/mise.toml          # Global mise-managed tools
└── config/                   # Shell and application configuration
```
