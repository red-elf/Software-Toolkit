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

if ! test -e "$DIR_DOWNLOADS"; then

    echo "ERROR: Downloads directory does not exist '$DIR_DOWNLOADS'"
    exit 1
fi

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

DOWNLOAD_FILE "$DOWNLOAD_URL_DATA_VERSION" "$DIR_INSTALLATION_HOME"

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

        # shellcheck disable=SC1090
        . "$FILE_RC" >/dev/null 2>&1

    else

        echo "WARNING: VSCode path was not added into '$FILE_RC' configuration"
    fi
fi

echo "Please provide your sudo password if asked in order to set the ownership and directory permissions properly for the VSCode"

if sudo chown -R "$USER" "$DIR_INSTALLATION_HOME" && sudo chgrp -R "$USER" "$DIR_INSTALLATION_HOME" && \
    sudo chmod -R 777 "$DIR_INSTALLATION_HOME"; then

    echo "Permissions for the VSCode directories have been set with success"

else

    echo "ERROR: Failed to set permissions for the VSCode directories"
    exit 1
fi

unset DATA_VERSION
unset DOWNLOAD_URL
unset DIR_INSTALLATION_HOME
unset DOWNLOAD_URL_USER_DATA
unset DOWNLOAD_URL_EXTENSIONS