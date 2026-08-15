#!/bin/bash
set -euo pipefail

echo "==> Patrik's mise bootstrap installer"

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

# Install mise if not present
if ! command -v mise &> /dev/null; then
    echo "==> Installing mise..."
    brew install mise
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

echo "==> Trusting and applying mise configuration..."
mise trust "$repo_dir/mise.toml"
mise bootstrap --yes

echo "==> Done! You may need to restart your terminal."
