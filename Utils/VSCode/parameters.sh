#!/bin/bash

if [ -z "$GENERAL_SERVER" ]; then

    echo "ERROR: 'GENERAL_SERVER' variable is not set"
    exit 1
fi

DIR_HOME="$(readlink --canonicalize ~)"

# shellcheck disable=SC2034
DATA_VERSION="1.0.0"

# shellcheck disable=SC2034
DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"

# shellcheck disable=SC2034
DIR_INSTALLATION_HOME="$DIR_HOME/VSCode"

# shellcheck disable=SC2034
DOWNLOAD_URL_EXTENSIONS="http://$GENERAL_SERVER:8081/extensions.1.0.0.tar.gz"

