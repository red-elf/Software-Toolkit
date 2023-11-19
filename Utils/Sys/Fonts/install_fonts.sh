#!/bin/bash

DIR_SOURCE="Assets/Fonts"
DIR_HOME=$(eval echo ~"$USER")
DIR_DESTINATION="$DIR_HOME/.local/share/fonts"

if [ -n "$1" ]; then

    DIR_SOURCE="$1"
fi

if [ -n "$2" ]; then

    DIR_DESTINATION="$2"
fi

if ! test -e "$DIR_SOURCE"; then

    echo "ERROR: The fonts source directory not found '$DIR_SOURCE'"
    exit 1
fi

if ! test -e "$DIR_DESTINATION"; then

    echo "ERROR: The fonts destination directory not found '$DIR_DESTINATION'"
    exit 1
fi

echo "Installing fonts into: '$DIR_DESTINATION'"

