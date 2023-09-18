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

if ! test -e "$DIR_INSTALLATION_HOME"; then

    if ! mkdir -p "$DIR_INSTALLATION_HOME"; then

        echo "ERROR: Could create installation directory '$DIR_INSTALLATION_HOME'"
        exit 1
    fi
fi

# TODO: If destination directory exists archive it as backup
#
if tar -xzf "$FILE_DOWNLOAD" -C "$DIR_INSTALLATION_HOME"; then

    echo "Extracted '$FILE_DOWNLOAD' into '$DIR_INSTALLATION_HOME'"

else

    echo "ERROR: Could not extract '$FILE_DOWNLOAD' into '$DIR_INSTALLATION_HOME'"
    exit 1
fi

# TODO: Extract installation and add to path
# TODO: Install extensions (pickup some mandatory and additional from user's optional recipes)

unset DOWNLOAD_URL
unset DIR_INSTALLATION_HOME

echo "ERROR: VSCode install script is not yet implemented"
exit 1