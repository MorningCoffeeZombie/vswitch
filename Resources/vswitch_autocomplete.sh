_vswitch() 
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="panic protocol remove enable distrobution disable recommend connect disconnect status unpanic update ipversion host help who region location"

	if [[ ${cur} == * ]] ; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	fi
}
complete -F _vswitch vswitch
# Find help at:
# https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1