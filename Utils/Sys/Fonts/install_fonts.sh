#!/bin/bash

DIR_SOURCE="Assets/Fonts"

if [ -n "$1" ]; then

    DIR_SOURCE="$1"
fi

if ! test -e "$DIR_SOURCE"; then

    echo "ERROR: The fonts source directory not found '$DIR_SOURCE'"
    exit 1
fi