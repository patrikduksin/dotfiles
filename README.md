# Patrik's Dotfiles

Declarative macOS configuration using nix-darwin, Home Manager, Homebrew, and mise.

## Setup

Homebrew and Determinate Nix must already be installed.

```bash
git clone https://github.com/patrikduksin/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix build .#darwinConfigurations.Patriks-MacBook-Pro.system --out-link result
sudo ./result/activate
mise trust ~/.config/mise/config.toml
mise install
bun install --cwd config/pi/onepassword-environment --frozen-lockfile
```

## Maintenance

Rebuild from any Fish shell:

```bash
rebuild
```

Update Nix inputs or mise tools explicitly:

```bash
cd ~/dotfiles
nix flake update
rebuild

mise upgrade
```

## Pi credentials

Create a 1Password Environment containing `EXA_API_KEY`, `TAVILY_API_KEY`, and `FIRECRAWL_API_KEY`, then put its Environment ID in `config/pi/onepassword-environment/config.json`.

On a new Mac, enable **Settings → Developer → Integrate with other apps** in 1Password. Pi loads the Environment at startup and on `/reload`.

## Manual steps

- Sign in to account-backed applications.
- Enable the 1Password SSH agent for Git signing.
- Grant the required macOS privacy permissions.
- Authenticate the Apple Account for Mac App Store installations.
