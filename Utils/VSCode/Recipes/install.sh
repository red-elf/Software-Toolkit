#!/bin/bash

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
FILE_DOWNLOAD="$DIR_DOWNLOADS/VSCode_Installation_$DAY_CODE.tar.gz"

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

if tar -xzf "$FILE_DOWNLOAD" -C "$DIR_INSTALLATION_HOME"; then

    echo "Extracted '$FILE_DOWNLOAD' into '$DIR_INSTALLATION_HOME'"

else

    echo "ERROR: Could not extract '$FILE_DOWNLOAD' into '$DIR_INSTALLATION_HOME'"
    exit 1
fi

APPEND_PATH="$DIR_INSTALLATION_HOME/VSCode-linux-x64"

if ! test -e "$APPEND_PATH"; then

    echo "ERROR: Path does not exist '$APPEND_PATH'"
    exit 1
fi

DIR_DATA="$APPEND_PATH/data"

if ! test -e "$DIR_DATA"; then

    if mkdir -p "$DIR_DATA"; then

        echo "Data directory has been created: '$DIR_DATA'"

    else

        echo "ERROR: data directory has not been created: '$DIR_DATA'"
        exit 1
    fi
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

# TODO: Install extensions (pickup some mandatory and additional from user's optional recipes)

unset DOWNLOAD_URL
unset DIR_INSTALLATION_HOME

echo "ERROR: VSCode install script is not yet implemented"
exit 1