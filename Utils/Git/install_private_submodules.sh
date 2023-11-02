#!/bin/bash

if [ -z "$1" ]; then

    echo "ERROR: Private modules directory parameter is mandatory"
    exit 1
fi

DIR_MODULES="$1"

echo "Checking and installing private modules from: '$DIR_MODULES'"

# TODO: Implement