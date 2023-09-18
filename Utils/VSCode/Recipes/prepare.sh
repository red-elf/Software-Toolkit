#!/bin/bash

if [ -z  "$DOWNLOAD_URL" ]; then

    echo "ERROR: DOWNLOAD_URL variable not defined"
    exit 1
fi

if [ -z  "$DIR_INSTALLATION_HOME" ]; then

    echo "ERROR: DIR_INSTALLATION_HOME variable not defined"
    exit 1
fi

DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"

if ! test -e "$DIR_DOWNLOADS"; then

    if ! mkdir -p "$DIR_DOWNLOADS"; then

        echo "ERROR: Could not crete downloads directory '$DIR_DOWNLOADS'"
        exit 1
    fi
fi


