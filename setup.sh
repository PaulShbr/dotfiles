# /bin/bash
# dependencies
brew install curl git stow nvim zoxide eza fzf tmux alacritty bat font-meslo-lg-nerd-font

# fzf tab plugin
git clone https://github.com/Aloxaf/fzf-tab ~/.config/fzf-tab/fzf-tab.plugin.zsh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# setup config
stow zsh
stow tmux
stow alacritty
