#================================================== ls
LSCOLORS=gxhxcxdxbxegedabagacad

#================================================== locale
export LANG=ja_JP.UTF-8
export LC_COLLATE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_MESSAGES=ja_JP.UTF-8
export LC_MONETARY=ja_JP.UTF-8
export LC_NUMERIC=ja_JP.UTF-8
export LC_TIME=en_US.UTF-8

#================================================== aws
export PATH=${PATH}:${HOME}/aws-cli/bin

#================================================== gcp
export CLOUDSDK_PYTHON=${HOME}/pyenv/shims/python3

#================================================== Homebrew
# Note
#  - xcode command line tools from "https://developer.apple.com/download/more"
#  - $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if [ ! -z "$(which brew)" ]; then
  export PATH="/usr/local/bin:${PATH}"
  export PATH="/usr/local/sbin:${PATH}"
fi

#================================================== direnv
export EDITOR=nano
eval "$(direnv hook bash)"

#================================================== pyenv
# Note
#  - git clone https://github.com/pyenv/pyenv.git ~/pyenv
if [ -d "${HOME}/pyenv" ]; then
  . ${HOME}/pyenv/completions/pyenv.bash
  export PYENV_ROOT="$HOME/pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

#================================================== jenv
# Note
#  - git clone https://github.com/gcuisinier/jenv.git ~/jenv
#  - jenv enable-plugin export
#  - jenv enable-plugin maven
if [ -d "${HOME}/jenv" ]; then
  . ${HOME}/jenv/completions/jenv.bash
  export JENV_ROOT="$HOME/jenv"
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi

#================================================== goenv
# Note
#  - git clone https://github.com/syndbg/goenv.git ~/goenv
if [ -d "${HOME}/goenv" ]; then
  . ${HOME}/goenv/completions/goenv.bash
  export GOENV_ROOT="$HOME/goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

#================================================== nodebrew
# Note
#  - brew install nodebrew
[ -d "${HOME}/.nodebrew/current/bin" ] &&
  export PATH=${HOME}/.nodebrew/current/bin:${PATH}

#================================================== scalaenv
# Note
#  - git clone git://github.com/scalaenv/scalaenv.git ~/scalaenv
if [ -d "${HOME}/scalaenv" ]; then
  . ${HOME}/scalaenv/completions/scalaenv.bash
  export SCALAENV_ROOT="${HOME}/scalaenv"
  export PATH="${HOME}/scalaenv/bin:${PATH}"
  eval "$(scalaenv init -)"
fi

#================================================== tfenv
[ -d "${HOME}/tfenv" ] &&
  export PATH="${HOME}/tfenv/bin:${PATH}"

#================================================== git
# Note
#  - brew install git
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1
[ -f '/usr/local/bin/git' ] &&
  export PATH="$PATH:/usr/local/share/git-core/contrib/diff-highlight"

#================================================== other softwares
# openssl
[ -d '/usr/local/opt/openssl' ] &&
  export PATH="/usr/local/opt/openssl/bin:$PATH"

# gettxt
[ -d '/usr/local/opt/gettext' ] &&
  export PATH="/usr/local/opt/gettext/bin:$PATH"

# GNU getopt
[ -d '/usr/local/opt/gnu-getopt' ] &&
  export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

#================================================== completion
# bash completion
[ -f $(brew --prefix)/etc/bash_completion ] &&
  . $(brew --prefix)/etc/bash_completion

# gcloud
[ -f "${HOME}/google-cloud-sdk/path.bash.inc" ] &&
  . "${HOME}/google-cloud-sdk/path.bash.inc"
[ -f "${HOME}/google-cloud-sdk/completion.bash.inc" ] &&
  . "${HOME}/google-cloud-sdk/completion.bash.inc"

# terraform
[ -f '/usr/local/bin/terraform' ] &&
  complete -C /usr/local/bin/terraform terraform

# docker
[ -f '/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion' ] &&
  . /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion
[ -f '/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion' ] &&
  . /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion

# terraform
complete -C ${HOME}/tfenv/versions/$(tfenv list | sed -n s/^\*//p | awk '{print $1}')/terraform terraform

# other
[ -d "${HOME}/.scripts/etc" ] &&
  . "${HOME}/.scripts/etc/completion.bash"

#================================================== bashrc
[ -f "${HOME}/.bashrc" ] && . ${HOME}/.bashrc

#================================================== flush window for PS1
clear
