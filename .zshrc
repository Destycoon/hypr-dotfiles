# Lines configured by zsh-newuser-install
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/destycoon/.zshrc'

autoload -Uz compinit
compinit

alias figlet='figlet -f "slant" $1'

alias pacman='sudo pacman'
alias la='ls -la --color=auto'
alias ll='ls -lh --color=auto'
alias gs='git status'
alias rl='source ~/.zshrc'
# End of lines added by compinstall

eval "$(starship init zsh)"

clear 
fastfetch
