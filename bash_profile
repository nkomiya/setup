#================================================== ls
export LSCOLORS=gxhxcxdxbxegedabagacad

#================================================== locale
export LANG=ja_JP.UTF-8
export LC_COLLATE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_MESSAGES=ja_JP.UTF-8
export LC_MONETARY=ja_JP.UTF-8
export LC_NUMERIC=ja_JP.UTF-8
export LC_TIME=en_US.UTF-8

#================================================== Homebrew
# Note
#  - xcode command line tools from "https://developer.apple.com/download/more"
#  - $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if [ ! -z "$(which brew)" ]; then
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export PATH="/usr/local/opt/gettext/bin:$PATH"
fi

#================================================== pyenv
# Note
#  - git clone https://github.com/pyenv/pyenv.git ~/pyenv
if [ -d "${HOME}/pyenv" ]; then
  . pyenv/completions/pyenv.bash
  export PYENV_ROOT="$HOME/pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

#================================================== jenv
# Note
#  - git clone https://github.com/gcuisinier/jenv.git ~/jenv
#  - jenv enable-plugin export
#  - jenv enable-plugin maven
if [ -d "${HOME}/jenv" ]; then
  . jenv/completions/jenv.bash
  export JENV_ROOT="$HOME/jenv"
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi

#================================================== node
# Note
#  - brew install nodebrew
[ -d "${HOME}/.nodebrew/current/bin" ] &&
    export PATH=${HOME}/.nodebrew/current/bin:${PATH}

#================================================== git
# Note
#  - brew install git
[ "$(which git)" = "/usr/local/bin/git" ] &&
    export PATH="$PATH":/usr/local/share/git-core/contrib/diff-highlight

#================================================== completion
# bash
[ -f '/usr/local/etc/profile.d/bash_completion.sh' ] &&
    . /usr/local/etc/profile.d/bash_completion.sh

# gcloud
[ -f "${HOME}/google-cloud-sdk/path.bash.inc" ] &&
    . "${HOME}/google-cloud-sdk/path.bash.inc"
[ -f "${HOME}/google-cloud-sdk/completion.bash.inc" ] &&
    . "${HOME}/google-cloud-sdk/completion.bash.inc"

# docker
[ -f '/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion' ] &&
    . /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion
[ -f '/Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion' ] &&
    . /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion
[ -f '/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion' ] &&
    . /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion

# other
[ -d "${HOME}/.scripts/etc" ] && . "${HOME}/.scripts/etc/completion.bash"

#================================================== bashrc
[ -f "${HOME}/.bashrc" ] && . ${HOME}/.bashrc

#================================================== flush window for PS1
clear
