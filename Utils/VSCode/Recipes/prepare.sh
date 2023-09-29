#!/bin/bash

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

DAY_CODE=$(date +%Y.%m.%d)
DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"
FILE_DOWNLOAD="$DIR_DOWNLOADS/VSCode_Installation_$DAY_CODE.tar.gz"
FILE_DOWNLOAD_EXTENSIONS="$DIR_DOWNLOADS/extensions_$DATA_VERSION.tar.gz"
FILE_DOWNLOAD_USER_DATA="$DIR_DOWNLOADS/user-data_$DATA_VERSION.tar.gz"

if ! test -e "$DIR_DOWNLOADS"; then

    if ! mkdir -p "$DIR_DOWNLOADS"; then

        echo "ERROR: Could not crete downloads directory '$DIR_DOWNLOADS'"
        exit 1
    fi
fi

DOWNLOAD_FILE() {

    if [ -z "$1" ]; then

        echo "Download URL parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "Download destination parameter is mandatory"
        exit 1
    fi

    DOWNLOAD_URL="$1"
    FILE_DOWNLOAD="$2"

    if test -e "$FILE_DOWNLOAD"; then

        echo "File has been already downloaded: '$FILE_DOWNLOAD'"
        
    else

        if wget "$DOWNLOAD_URL" -O "$FILE_DOWNLOAD"; then

            echo "File '$FILE_DOWNLOAD' has been downloaded with success"

        else

            echo "ERROR: '$FILE_DOWNLOAD' has failed to downloaded"
            exit 1
        fi
    fi
}

DOWNLOAD_FILE "$DOWNLOAD_URL" "$FILE_DOWNLOAD"
DOWNLOAD_FILE "$DOWNLOAD_URL_EXTENSIONS" "$FILE_DOWNLOAD_EXTENSIONS"

if [ -n "$DOWNLOAD_URL_USER_DATA" ]; then

    DOWNLOAD_FILE "$DOWNLOAD_URL_USER_DATA" "$FILE_DOWNLOAD_USER_DATA"
fi
