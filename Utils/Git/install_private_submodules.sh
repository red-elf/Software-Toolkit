#!/bin/bash

if [ -z "$1" ]; then

    echo "ERROR: Private modules home directory parameter is mandatory"
    exit 1
fi

if [ -z "$2" ]; then

    echo "ERROR: Private modules recipes directory parameter is mandatory"
    exit 1
fi

DIR_MODULES_HOME="$1"
DIR_RECIPES="$2"

echo "Checking and installing private modules from '$DIR_RECIPES' into '$DIR_MODULES_HOME'"

# TODO: Implement