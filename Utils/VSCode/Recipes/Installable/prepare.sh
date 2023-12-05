#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_DOWNLOAD_FILE="$SUBMODULES_HOME/Software-Toolkit/Utils/download_file.sh"

if test -e "$SCRIPT_DOWNLOAD_FILE"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_DOWNLOAD_FILE"

else

    echo "ERROR: Script not found '$DOWNLOAD_FILE'"
    exit 1
fi

if [ -z  "$DATA_VERSION" ]; then

    echo "ERROR: DATA_VERSION variable not defined"
    exit 1
fi

if [ -z  "$DOWNLOAD_URL" ]; then

    echo "ERROR: DOWNLOAD_URL variable not defined"
    exit 1
fi

if [ -z  "$DIR_INSTALLATION_HOME" ]; then

    echo "ERROR: DIR_INSTALLATION_HOME variable not defined"
    exit 1
fi

if [ -z  "$DOWNLOAD_URL_EXTENSIONS" ]; then

    echo "ERROR: DOWNLOAD_URL_EXTENSIONS variable not defined"
    exit 1
fi

if [ -z  "$DOWNLOAD_URL_DATA_VERSION" ]; then

    echo "ERROR: DOWNLOAD_URL_DATA_VERSION variable not defined"
    exit 1
fi

DAY_CODE=$(date +%Y.%m.%d)
DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"
FILE_DOWNLOAD="$DIR_DOWNLOADS/VSCode_Installation.$DAY_CODE.tar.gz"
FILE_DOWNLOAD_EXTENSIONS="$DIR_DOWNLOADS/extensions.$DATA_VERSION.tar.gz"
FILE_DOWNLOAD_USER_DATA="$DIR_DOWNLOADS/user-data.$DATA_VERSION.tar.gz"

if ! test -e "$DIR_DOWNLOADS"; then

    if ! mkdir -p "$DIR_DOWNLOADS"; then

        echo "ERROR: Could not crete downloads directory '$DIR_DOWNLOADS'"
        exit 1
    fi
fi

DOWNLOAD_FILE "$DOWNLOAD_URL" "$FILE_DOWNLOAD"
DOWNLOAD_FILE "$DOWNLOAD_URL_EXTENSIONS" "$FILE_DOWNLOAD_EXTENSIONS"

if [ -n "$DOWNLOAD_URL_USER_DATA" ]; then

    DOWNLOAD_FILE "$DOWNLOAD_URL_USER_DATA" "$FILE_DOWNLOAD_USER_DATA"
fi
