
set fish_gretting


if status is-interactive
	fastfetch


	eval "$(starship init fish)"
	alias upclean='bash ~/.config/scripts/clean.sh'
		
	alias rl='clear; source ~/.config/fish/config.fish'
end


