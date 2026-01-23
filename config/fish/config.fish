# Fish shell configuration

# Nix
set -gx PATH /run/current-system/sw/bin $PATH

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv fish)"

# Starship prompt
starship init fish | source

# Bun
set -gx BUN_INSTALL $HOME/.bun
set -gx PATH $BUN_INSTALL/bin $PATH

# mise (version manager)
mise activate fish | source

# Local binaries
set -gx PATH $HOME/.local/bin $PATH

# Aliases
alias ls="eza"
alias ll="eza -la"
alias cat="bat"
alias find="fd"
alias rebuild="sudo darwin-rebuild switch --flake $HOME/dotfiles"
