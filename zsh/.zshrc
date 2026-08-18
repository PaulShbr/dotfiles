# ~/.zshrc

# --- Editor ---
export EDITOR="nvim"
export VISUAL="nvim"

# --- Keybindings ---
bindkey -e
bindkey '^r' history-search-backward
bindkey '^n' history-search-forward

# --- History ---
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt autocd

# --- Completion ---
autoload -U compinit && compinit

# --- Tool-Integrationen ---
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --border --preview-window=right:50%'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Aliases: allgemein ---
alias vim='nvim'
alias c='clear'
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -la --icons=always --group-directories-first --git'
alias lt='eza --tree --level=2 --icons=always'
alias cat='bat --style=plain'
alias grep='rg'
alias find='fd'
alias cd='z'

# --- Aliases: git ---
alias gs='git status -s'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias lg='lazygit'
