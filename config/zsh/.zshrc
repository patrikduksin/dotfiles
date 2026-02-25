# Interactive zsh configuration.
# Shared environment setup lives in .zshenv.

[[ $- != *i* ]] && return

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# mise (version manager)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# direnv (auto-load .envrc files)
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Aliases
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias find='fd'
alias rebuild='sudo darwin-rebuild switch --flake $HOME/dotfiles'
