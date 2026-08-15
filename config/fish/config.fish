# Fish shell configuration

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv fish)"

# Starship prompt
starship init fish | source

# mise (version manager)
mise activate fish | source

# direnv (auto-load .envrc files)
direnv hook fish | source

# Smarter directory navigation
zoxide init fish | source

# Fuzzy finder shell integration
fzf --fish | source

# Local binaries
set -gx PATH $HOME/.local/bin $PATH

# Aliases
alias ls="eza"
alias ll="eza -la"
alias cat="bat"
alias find="fd"
alias rebuild="mise -C $HOME/dotfiles bootstrap"
alias docker-start="colima start"
alias docker-stop="colima stop"
