#!/bin/bash

if [ -z  "$DOWNLOAD_URL" ]; then

    echo "ERROR: DOWNLOAD_URL variable not defined"
    exit 1
fi

if [ -z  "$DIR_INSTALLATION_HOME" ]; then

    echo "ERROR: DIR_INSTALLATION_HOME variable not defined"
    exit 1
fi


# TODO: Extract installation and add to path
# TODO: Install extensions (pickup some mandatory and additional from user's optional recipes)

unset DOWNLOAD_URL
unset DIR_INSTALLATION_HOME

echo "ERROR: VSCode install script is not yet implemented"
exit 1