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

DAY_CODE=$(date +%Y.%m.%d)
DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"

FILE_ZSH_RC="$DIR_HOME/.zshrc"
FILE_BASH_RC="$DIR_HOME/.bashrc"

FILE_EXTENSIONS="$DIR_DOWNLOADS/extensions.$DATA_VERSION.tar.gz"
FILE_USER_DATA="$DIR_DOWNLOADS/user-data.$DATA_VERSION.tar.gz"
FILE_DOWNLOAD="$DIR_DOWNLOADS/VSCode_Installation.$DAY_CODE.tar.gz"

FILE_RC=""
    
if test -e "$FILE_ZSH_RC"; then

  FILE_RC="$FILE_ZSH_RC"

else

    if test -e "$FILE_BASH_RC"; then

      FILE_RC="$FILE_BASH_RC"

    else

      echo "ERROR: No '$FILE_ZSH_RC' or '$FILE_BASH_RC' found on the system"
      exit 1
    fi
fi

if test -e "$DIR_INSTALLATION_HOME"; then
    
    HERE=$(pwd)
    BACKUP_CODE=$(date +%Y.%m.%d.%H%M%S)
    BACKUP_FILE="backup_$BACKUP_CODE.tar.gz"
    DIR_NAME=$(basename "$DIR_INSTALLATION_HOME")

    if cd "$DIR_INSTALLATION_HOME/.." && tar -cvz -f "$DIR_INSTALLATION_HOME/../$BACKUP_FILE" "$DIR_NAME" && cd "$HERE"; then

        echo "Backup has been created: '$DIR_INSTALLATION_HOME' -> '$BACKUP_FILE'"

        if rm -rf "$DIR_INSTALLATION_HOME"; then

            echo "Directory has been removed: '$DIR_INSTALLATION_HOME'"

        else

            echo "ERROR: Directory has not been removed: '$DIR_INSTALLATION_HOME'"
            exit 1
        fi

    else

        echo "ERROR: Backup has failed to create '$DIR_INSTALLATION_HOME' -> '$BACKUP_FILE'"
        exit 1
    fi
fi

if ! test -e "$DIR_INSTALLATION_HOME"; then

    if ! mkdir -p "$DIR_INSTALLATION_HOME"; then

        echo "ERROR: Could create installation directory '$DIR_INSTALLATION_HOME'"
        exit 1
    fi
fi

EXTRACT_INTO() {

    if [ -z "$1" ]; then

        echo "ERROR: Archive parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Destination parameter is mandatory"
        exit 1
    fi

    ARCHIVE="$1"
    DESTINATION="$2"

    if tar -xzf "$ARCHIVE" -C "$DESTINATION"; then

        echo "Extracted '$ARCHIVE' into '$DESTINATION'"

    else

        echo "ERROR: Could not extract '$ARCHIVE' into '$DESTINATION'"
        exit 1
    fi
}

DIR_VS_CODE_ROOT="VSCode-linux-x64"
APPEND_PATH="$DIR_INSTALLATION_HOME/$DIR_VS_CODE_ROOT"
DIR_DATA="$APPEND_PATH/data"
DIR_TMP="$DIR_DATA/tmp"

if ! test -e "$DIR_TMP"; then

    if ! mkdir -p "$DIR_TMP"; then

        echo "ERROR: data directory has not been created: '$DIR_DATA'"
        exit 1
    fi
fi

EXTRACT_INTO "$FILE_DOWNLOAD" "$DIR_INSTALLATION_HOME"

if test -e "$FILE_USER_DATA"; then

    EXTRACT_INTO "$FILE_USER_DATA" "$DIR_DATA"
fi

if test -e "$FILE_EXTENSIONS"; then

    EXTRACT_INTO "$FILE_EXTENSIONS" "$DIR_DATA"
fi

if ! test -e "$APPEND_PATH"; then

    echo "ERROR: Path does not exist '$APPEND_PATH'"
    exit 1
fi

APPEND="export PATH=\${PATH}:$APPEND_PATH"

# shellcheck disable=SC2002
if cat "$FILE_RC" | grep "$APPEND" >/dev/null 2>&1; then

    echo "VSCode path is already added into '$FILE_RC' configuration"    

else

    if echo "" >> "$FILE_RC" && echo "$APPEND" >> "$FILE_RC"; then

        echo "VSCode path is added into '$FILE_RC' configuration"

    else

        echo "WARNING: VSCode path was not added into '$FILE_RC' configuration"
    fi
fi

unset DATA_VERSION
unset DOWNLOAD_URL
unset DIR_INSTALLATION_HOME
unset DOWNLOAD_URL_USER_DATA
unset DOWNLOAD_URL_EXTENSIONS

echo "ERROR: VSCode install script is not yet implemented"
exit 1