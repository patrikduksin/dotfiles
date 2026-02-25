# Zsh environment (loaded for interactive and non-interactive shells)

# Keep PATH entries unique while preserving prepend order.
typeset -U path PATH

# Nix
path=(/run/current-system/sw/bin $path)

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Local binaries
if [ -d "$HOME/.local/bin" ]; then
  path=("$HOME/.local/bin" $path)
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL/bin" ]; then
  path=("$BUN_INSTALL/bin" $path)
fi

# mise shims (so non-interactive shells resolve tool versions too)
if [ -d "$HOME/.local/share/mise/shims" ]; then
  path=("$HOME/.local/share/mise/shims" $path)
fi

export PATH
