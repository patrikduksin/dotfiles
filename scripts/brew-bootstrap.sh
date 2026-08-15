#!/bin/bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Taps must exist before Homebrew can mark them as trusted.
brew tap nikitabobko/tap
brew tap anomalyco/tap
brew tap entireio/tap

if brew commands | tr ' ' '\n' | grep -qx trust; then
  brew trust --tap anomalyco/tap nikitabobko/tap entireio/tap
fi

brew bundle --file="$repo_dir/Brewfile"
