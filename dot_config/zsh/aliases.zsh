# ~/.config/zsh/aliases.zsh

# navigation
alias ..="cd .."
alias ...="cd ../.."

# the ls situation — you clearly have eza or lsd, alias accordingly
alias ls="eza --icons"
alias ll="eza -lha --icons"
alias lt="eza --tree --level=2"

# git
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -15"

# editor
alias v="nvim"
alias vim="nvim"

# the reload alias from earlier
alias reload="source $ZDOTDIR/.zshrc"

# chezmoi quality-of-life
alias cz="chezmoi"
alias cze="chezmoi edit"
alias czd="chezmoi diff"

# other 
alias show-keys="glow $HOME/.config/keys.md"

# yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  YAZI_LAUNCH_DIR="$PWD" yazi "$@" --cwd-file="$tmp"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
