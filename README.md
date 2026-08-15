# Patrik's Dotfiles

Declarative macOS workstation setup powered by [mise bootstrap](https://mise.jdx.dev/bootstrap.html), native mise package management, and symlinked dotfiles.

## Fresh Mac Setup

### 1. Clone the repository

```bash
git clone https://github.com/patrikduksin/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer

```bash
./install.sh
```

The installer:

1. Installs Homebrew when needed.
2. Installs mise.
3. Trusts this repository's `mise.toml`.
4. Runs `mise bootstrap --yes`.

Bootstrap converges the dotfiles, macOS preferences, keyboard LaunchAgent, login shell, global development tools, Homebrew packages, applications, fonts, and remaining idempotent setup.

## Everyday Commands

```bash
# Reapply the desired machine state
mise -C ~/dotfiles bootstrap

# Preview declarative changes
mise -C ~/dotfiles bootstrap --dry-run

# Inspect declarative state
mise -C ~/dotfiles bootstrap status

# Upgrade native packages, the three Homebrew casks, and mise tools
mise -C ~/dotfiles run update
```

The `rebuild` alias runs the first command.

## What's Included

### Homebrew

`Brewfile` owns only Entire, AeroSpace, and Microsoft Teams because their custom metadata or installer behavior is not supported by mise. Homebrew remains as a narrow compatibility layer for those three casks.

### mise packages and tools

`mise.toml` natively installs the remaining Homebrew formulae, GUI applications, fonts, Infuse, Bun, Node.js, pnpm, Rust, uv, Prettier, Codex, Claude Code, OpenCode through Bun, eas-cli, agent-browser, pi-coding-agent, and related global tools.

### Dotfiles

- Fish and Zsh
- Git with 1Password SSH signing
- Starship
- mise
- Aerospace
- Ghostty
- Herdr

### macOS configuration

- Dock, Finder, keyboard, trackpad, menu-bar clock, and dark mode defaults
- Raycast on Command-Space with Spotlight shortcuts disabled
- U.S. and RussianWin input sources
- F4/F5/F6 hardware-key remapping through a mise-managed LaunchAgent
- Touch ID for `sudo`
- Docker Compose and buildx plugin discovery for the Homebrew Docker CLI

## Manual Steps

### Accounts and permissions

Sign in to 1Password, Raycast, communication apps, Spotify, Notion, Figma, and other account-backed applications. Enable the 1Password SSH agent so Git signing works. macOS privacy permissions and Apple Account authentication cannot be automated safely.

### Cursor extensions

Install these manually:

```text
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

### Security reminder

An older Fish configuration contained an exposed GitHub token. Confirm it remains revoked at <https://github.com/settings/tokens>.

## Repository Layout

```text
~/dotfiles/
├── mise.toml                  # Workstation state, tools, defaults, tasks
├── Brewfile                   # Three Homebrew-only compatibility casks
├── install.sh                 # New-machine entry point
├── scripts/                   # Idempotent bootstrap helpers
└── config/                    # Files symlinked into the home directory
```

## Migrating an Existing Nix-managed Mac

Running `./install.sh` repoints the Home Manager-owned dotfile symlinks to this repository and applies the mise configuration. It intentionally does not uninstall Nix or delete `/nix`; remove the old Nix installation separately only after verifying that `mise bootstrap status` and your daily tools work as expected.

Existing Homebrew-owned casks cannot be adopted in place by mise. On this Mac, an ignored `mise.local.toml` temporarily disables native cask operations so the installed apps remain untouched. Fresh Macs use native mise casks immediately. Remove the local override only after deliberately uninstalling the standard casks with Homebrew so mise can reinstall and own them.
