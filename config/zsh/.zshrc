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

# Smarter directory navigation
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Fuzzy finder shell integration
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Aliases
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias find='fd'
alias rebuild='mise -C $HOME/dotfiles bootstrap'
alias docker-start='colima start'
alias docker-stop='colima stop'
