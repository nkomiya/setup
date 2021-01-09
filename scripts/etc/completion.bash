#!/bin/bash

COMP_DIR=${HOME}/.scripts/etc/completion.d
[ -d "${COMP_DIR}" ] && for f in $(find ${COMP_DIR} -type f -name "*.bash"); do
  . $f
done
