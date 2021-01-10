#!/bin/bash

cd $(dirname $0)/.. || exit 1

# copy
cp bash_profile ./build/bash_profile

# GCP
path_to_keyfile=$(echo ${GOOGLE_APPLICATION_CREDENTIALS} | sed "s!${HOME}!\${HOME}!")
sed -i "" "s!REPLACE-GOOGLE_APPLICATION_CREDENTIALS!${path_to_keyfile}!" ./build/bash_profile

# AWS
sed -i "" "s/REPLACE-AWS_PROFILE/${AWS_PROFILE}/" ./build/bash_profile

# Spark
echo -n "Spark installed directory > "
read SPARK_DIR
SPARK_DIR=$(echo $SPARK_DIR | sed -e 's|~|\${HOME}|' -e 's|/*$|/|')

SPARK_BIN_DIR=$(ls -1 $(eval "echo ${SPARK_DIR}") | grep '^spark-[0-9.]\{1,\}-bin-hadoop[0-9.]\{1,\}$' | sort | tail -1)
if [[ -z "${SPARK_BIN_DIR}" ]]; then
    grep -v "REPLACE-SPARK_BIN_DIR" ./build/bash_profile >./build/tmp
    mv ./build/tmp ./build/bash_profile
else
    sed -i "" "s|REPLACE-SPARK_BIN_DIR|${SPARK_DIR}${SPARK_BIN_DIR}/bin|" ./build/bash_profile
fi

# git
bash ./helper/sub/configure_git.sh
