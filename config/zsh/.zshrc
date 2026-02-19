# Zsh shell configuration

# Nix
export PATH="/run/current-system/sw/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Starship prompt
eval "$(starship init zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# mise (version manager)
eval "$(mise activate zsh)"

# direnv (auto-load .envrc files)
eval "$(direnv hook zsh)"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias find='fd'
alias rebuild='sudo darwin-rebuild switch --flake $HOME/dotfiles'
