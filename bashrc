#================================================== alias
alias ls='ls -G'
alias ll='ls -ltr'
alias la='ls -a'
alias grep='grep --color=auto'
alias brew="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin brew"
alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
alias ts2date='__f(){ date -r $1 "+%Y/%m/%d-%H:%M:%S %Z"; }; __f'
alias date2ts='__f(){ date -j -f "%Y/%m/%d-%H:%M:%S" "$1" "+%s"; }; __f'
alias docker-tags='__f(){
    curl -s https://registry.hub.docker.com/v1/repositories/$1/tags | jq -r .[].name
}; __f'
alias sv='__f() {
    if [ $# -eq 0 ]; then
      echo "Usage: sv FILENAME"
      return 1
    fi

    local fname=$1; shift;
    if [ ! -f "${fname}" ]; then
        echo "${fname}: No such file"
        return 1
    fi

    # color schema
    local schema_file="${HOME}/.scripts/share/source-highlight/conf"
    if [[ -f "${schema_file}" ]]; then
        local schema="--style-file ${schema_file}"
    fi

    # start pager
    /usr/local/bin/source-highlight --failsafe ${schema} -f esc -i ${fname} $@ | /usr/bin/less -R
}; __f'

#================================================== aws
complete -C "${HOME}/aws-cli/bin/aws_completer" aws

#================================================== kubectl
alias k=kubectl
complete -o default -F __start_kubectl k

#================================================== my scripts
PATH=${PATH}:${HOME}/.scripts/bin

#================================================== antlr
alias antlr4='java -cp "${HOME}/antlr/antlr-4.8-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias crun='javac -cp ".:${HOME}/antlr/antlr-4.8-complete.jar:$CLASSPATH"'
alias grun='java -cp "${HOME}/antlr/antlr-4.8-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

#================================================== PS1
__output_to_prompt() {
    local text prev current text_color

    text="$1"
    prev="$2"
    current="$3"
    text_color=$([[ -z "$4" ]] && echo 232 || echo "$4")

    tput sgr0
    if [[ ${prev} -ge 0 ]]; then
        tput setaf ${prev} && tput setab ${current}
        echo -n ""
    fi

    tput sgr0
    tput setab ${current} && tput setaf ${text_color}
    echo -n " ${text} "
}

__dirname_ps1() {
    local path level

    path=$1

    level=$(echo "${path}" | tr / "\n" | grep -v "^$" | wc -l)
    if [[ "${level}" -gt 2 ]]; then
        echo ".../"$(echo "${path}" | rev | cut -d/ -f1,2 | rev)
    else
        echo "${path}"
    fi
}

__gcloud_ps1() {
    echo "gcloud:"$(cat ${HOME}/.config/gcloud/active_config)
}

__git_has_upstream() {
    local branch upstream

    branch=$(git branch --show-current)
    upstream=$(git status -sb | head -n 1 | sed "s|## ${branch}||")
    [[ "${upstream:0:3}" = '...' ]] && true || false
}

__git_ps1() {
    local info ahead behind modified untracked

    info=$(git status -sb | head -1)
    ahead=$(echo "${info}" | sed -ne 's/^.*ahead \([0-9]\{1,\}\).*$/\1/p')
    behind=$(echo "${info}" | sed -ne 's/^.*behind \([0-9]\{1,\}\).*$/\1/p')
    modified=$(git status -sb | sed -e 1,1d | grep -v "^??" | wc -l)
    untracked=$(git ls-files --exclude-standard --others $(git rev-parse --show-toplevel) | wc -l)

    echo -n " $(git branch --show-current)"
    if [[ ! -z "${ahead}" ]] || [[ ! -z "${behind}" ]] || [[ ${modified} -ne 0 ]] || [[ ${untracked} -ne 0 ]]; then
        echo -n " "
        [[ ! -z "${ahead}" ]] && printf " %dA" ${ahead}
        [[ ! -z "${behind}" ]] && printf " %dB" ${behind}
        [[ ${modified} -ne 0 ]] && printf " %dM" ${modified}
        [[ ${untracked} -ne 0 ]] && printf " %dU" ${untracked}
    fi
}

__my_ps1() {
    local val prev nxt

    # time
    __output_to_prompt "$1" -1 230
    prev=230

    # directory
    __output_to_prompt "$(__dirname_ps1 $2)" ${prev} 50
    prev=50

    # gcloud configuration
    val=$(__gcloud_ps1)
    [[ "$val" = "gcloud:default" ]] && nxt=39 || nxt="228 9"
    __output_to_prompt "$val" ${prev} ${nxt}
    prev=$(echo "${nxt}" | cut -d" " -f1)

    # git
    if git status -s &>/dev/null; then
        $(__git_has_upstream) && nxt="9 231" || nxt=78
        __output_to_prompt "$(__git_ps1)" ${prev} ${nxt}
        prev=$(echo "${nxt}" | cut -d" " -f1)
    fi

    tput sgr0
    tput setaf ${prev} && echo -n ""
    tput sgr0
}

__add_new_line() {
    if [ -z "${PS1_NEWLINE_LOGIN}" ]; then
        PS1_NEWLINE_LOGIN=true
    else
        echo
    fi
}
if ! [[ "${PROMPT_COMMAND:-}" =~ _add_new_line ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}__add_new_line"
fi

PS1='$(
if [ $UID -eq 0 ]; then
    echo "\[\e[1;4;31m\]\u@\W \[\e[0;1;31m\]\$ \[\e[0m\]";
else
    printf "$(__my_ps1 "\d \t" "\w")"
fi
)\n\$ '
