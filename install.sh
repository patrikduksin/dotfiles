#!/bin/bash
set -e

echo "==> Patrik's Dotfiles Installer"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is only for macOS"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "==> Homebrew already installed"
fi

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "==> Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

    # Source nix
    if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
else
    echo "==> Nix already installed"
fi

# Build and apply nix-darwin configuration
echo "==> Building and applying nix-darwin configuration..."
cd "$(dirname "$0")"
nix run nix-darwin -- switch --flake .

echo "==> Done! You may need to restart your terminal."
