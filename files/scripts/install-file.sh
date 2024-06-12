#!/bin/bash

source=${1}
target=${2}

if [ -f ${source} ]; then
    mkdir -p $(dirname ${target})
    cp -R ${source} ${target}
fi
