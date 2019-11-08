#================================================== alias
alias ls='ls -G'
alias ll='ls -ltr'
alias la='ls -a'
alias brew="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin brew"
alias sv='f(){ __view_source $@; }; f'

#================================================== functions
__view_source() {
    local fname schema_file schema

    if [ $# -eq 0 ]; then
      echo "Usage: sv FILENAME"
      return 1
    fi

    fname=$1; shift;
    if [ ! -f "${fname}" ]; then
	echo "${fname}: No such file"
	return 1
    fi

    # color schema
    schema_file="${HOME}/.scripts/share/source-highlight/conf"
    [ -f "${schema_file}" ] &&
	schema="--style-file ${schema_file}"

    # start pager
    /usr/local/bin/source-highlight --failsafe ${schema} -f esc -i ${fname} $@ | /usr/bin/less -R
}

#================================================== PS1
__my_ps1() {
    local dname brname upstreamInfo ahead behind
    local _af _ab

    # time
    tput setab 230 && tput setaf 0
    printf " %s " "$1"
    tput setaf 230 && tput setab 50
    printf "%s" ""

    # directory
    dname=$(__dirname_ps1 "$2" "$3")
    tput setaf 0
    printf " %s " "${dname}"
    tput sgr0

    # git
    git st -sb > /dev/null 2>&1
    if [ $? -ne 0 ]; then
	tput sgr0 && tput setaf 50 && echo -n ""
    else
	# git
	brname=$(git branch --show-current)
	upstreamInfo=$(git st -sb | head -n 1 | sed -e "s/## ${brname//\//\/}//" -e "s/^\.\.\.//")
	if [ ! -z "${upstreamInfo}" ] && [ "${upstreamInfo}" != "## No commits yet on master" ]; then
	    _af=231
	    _ab=9
	    #
	    echo "${upstreamInfo}" | grep -E "ahead [0-9]+" >/dev/null 2>&1 &&
		ahead=$(echo "${upstreamInfo}" | sed -e "s/^.*ahead \([0-9]\{1,\}\).*$/\1/")
	    echo "${upstreamInfo}" | grep -E "behind [0-9]+" >/dev/null 2>&1 &&
		behind=$(echo "${upstreamInfo}" | sed -e "s/^.*behind \([0-9]\{1,\}\).*$/\1/")
	else
	    _af=0
	    _ab=47
	fi

	tput setaf 50 && tput setab ${_ab} && echo -n ""
	tput setaf ${_af} && printf " %s" " ${brname}"
	if [ ! -z "${ahead}" ] || [ ! -z "${behind}" ]; then
	    echo -n " "
	    [ ! -z "${ahead}" ] && printf " %d ahead" ${ahead}
	    [ ! -z "${behind}" ] && printf " %d behind" ${behind}
	fi
	echo -n " "
	tput sgr0 && tput setaf ${_ab} && echo -n ""
    fi

    tput sgr0
}


__dirname_ps1() {
    if [[ "$1" =~ /[^/]*/[^/]*/ ]]; then
	echo ".../$(basename $(dirname $1))/$2"
    else
	echo "$1"
    fi
}


__add_new_line() {
  if [ -z "${PS1_NEWLINE_LOGIN}" ]; then
    PS1_NEWLINE_LOGIN=true
  else
    echo
  fi
}
PROMPT_COMMAND='__add_new_line'


PS1='$(
if [ $UID -eq 0 ]; then
    echo "\[\e[1;4;31m\]\u@\W \[\e[0;1;31m\]\$ \[\e[0m\]";
else
    printf "$(__my_ps1 "\d \t" "\w" "\W")"
fi
)\n\$ '
#
export PS1
