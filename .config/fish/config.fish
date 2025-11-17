
function fish_greeting
	fastfetch
end
if status is-interactive
	starship init fish | source
	alias upclean='bash ~/.config/scripts/clean.sh'
	
	alias deploy='bash ~/.config/scripts/deploy.sh'
	alias rl='clear; source ~/.config/fish/config.fish; fish_greeting'

	bat --completion fish | source
	alias cat='bat'


	zoxide init fish | source
	alias cd='z'
end


