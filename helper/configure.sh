#!/bin/bash

git config --global diff.compactionHeuristic true

# color
git config --global color.diff.old '245 normal'
git config --global color.diff.meta '89 normal'
git config --global color.diff.frag '17 15'
git config --global color.diff.new '110'

# diff
git config --global pager.log 'diff-highlight | less'
git config --global pager.show 'diff-highlight | less'
git config --global pager.diff 'diff-highlight | less'

# kubectl
gitroot=$(cd $(dirname $0) && git rev-parse --show-toplevel)
[ ! -z "$(which kubectl)" ] &&
    kubectl completion bash > ${gitroot}/scripts/etc/completion.d/kubectl-completion.bash
