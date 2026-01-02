#eza completions
export FPATH="~/.config/eza-community/completions/zsh:$FPATH"

# Keybindings
bindkey -e
bindkey '^r' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey -s '^f' 'zi^M'
bindkey -s "^d" "clear^M"

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt autocd

# Aliases
alias vim='nvim'
alias c='clear'
alias ls="eza --icons=always"
alias cd="z"
alias tn="tmux new -A -s main"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# This setting also does not set the output color of this matching character
export FZF_DEFAULT_OPTS='--color=bg+:#14161B,bg:#14161B,border:white,spinner:white,hl:#A6DBFF,fg:white,header:#A6DBFF,info:#FCE094,pointer:white,marker:#E17899,fg+:white,preview-bg:#14161B,prompt:white,hl+:#719899'

autoload -U compinit; compinit
source ~/.config/fzf-tab/fzf-tab.plugin.zsh

zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'if [ -d $realpath ]; then ls -la $realpath; else bat $realpath; fi'

NEWLINE=$'\n'
PROMPT="[%T] %n@%B%m%b in %B%d%b ${NEWLINE}> "
#if [ "$TMUX" = "" ]; then tmux; fi

op(){
  local base_dir="$HOME/Projekte"
  local projekt
  local session

  projekt=$(find ~/Projekte -type d -mindepth 1 -maxdepth 1 \
    | sed "s|^$base_dir/||" \
    | sort \
    | fzf --prompt="Projekt auswählen: ")

  [[ -z "$projekt" ]] && return

    # 🔒 tmux-sicheren Session-Namen erzeugen
  session=$(echo "$projekt" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9_-]/_/g')

  local dir="$base_dir/$projekt"

  if [[ -n "$TMUX" ]]; then
    # Bereits in tmux
    if ! tmux has-session -t "$session" 2>/dev/null; then
      tmux new-session -d -s "$session" -c "$dir"
    fi
    tmux switch-client -t "$session"
  else
    # Noch nicht in tmux
    tmux new-session -A -s "$session" -c "$dir" -d
  fi 
}

nn(){
  zle -I
  python3 ~/.dotfiles/helper/new_note.py
}

fn() {
  file_path=$(fd . ~/Documents/Zettelkasten -t f | fzf  --preview="bat {}" --exact)
  if [[ "$file_path" = "" ]]; then
    return
  fi

  read "file_edit?Die Datei $file_path editieren [y/N] ? "

  if [[ $file_edit = "y" ]]; then
    nvim "$file_path"
  fi
}


zle -N op 
bindkey '^p' op 

zle -N fn 
bindkey '^f' fn 


