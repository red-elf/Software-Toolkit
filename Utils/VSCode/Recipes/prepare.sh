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
FILE_DOWNLOAD="$DIR_DOWNLOADS/VSCode_Installation.tar.gz"

if ! test -e "$DIR_DOWNLOADS"; then

    if ! mkdir -p "$DIR_DOWNLOADS"; then

        echo "ERROR: Could not crete downloads directory '$DIR_DOWNLOADS'"
        exit 1
    fi
fi

if test -e "$FILE_DOWNLOAD"; then

    if ! rm -f "$FILE_DOWNLOAD"; then

        echo "ERROR: Could not remove downloaded file '$FILE_DOWNLOAD'"
        exit 1
    fi
fi

if wget "$DOWNLOAD_URL" -O "$FILE_DOWNLOAD"; then

    echo "VSCode has been downloaded with success"

else

    echo "ERROR: VSCode has failed to downloaded"
    exit 1
fi


