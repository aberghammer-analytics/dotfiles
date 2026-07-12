# ~/.config/zsh/env.zsh

# core
export EDITOR="nvim"
export VISUAL="nvim"

# homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# tool inits — each of these hooks into the shell
eval "$(zoxide init zsh)"      # if you use zoxide
eval "$(fzf --zsh)"            # fzf keybinds (ctrl-r history search)

# bun
export PATH="$HOME/.bun/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

