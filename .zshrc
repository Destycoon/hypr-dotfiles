# ==========================
# Options ZSH
# ==========================
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt autocd extendedglob nomatch
unsetopt beep notify

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -e

# ==========================
# Completion
# ==========================
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit bashcompinit
compinit -C
bashcompinit


# ==========================
# Aliases
# ==========================
alias figlet='figlet -f "slant" $1'

alias deploy='bash $HOME/.config/scripts/deploy.sh'
alias sp='sudo pacman'
alias la='ls -la --color=auto'
alias ll='ls -lh --color=auto'
alias gs='git status'
alias rl='source ~/.zshrc'
alias upclean='bash $HOME/.config/scripts/clean.sh'
alias cat='bat'

# ==========================
# Prompt & Affichage
# ==========================
eval "$(starship init zsh)"
clear
fastfetch

#
# Autre
# 

export QT_QPA_PLATFORMTHEME=qt5ct
