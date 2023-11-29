#!/bin/bash

FILE_RC=""
DIR_HOME=$(eval echo ~"$USER")

export FILE_ZSH_RC="$DIR_HOME/.zshrc"
export FILE_BASH_RC="$DIR_HOME/.bashrc"

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

export FILE_RC
export DIR_HOME

ADD_TO_PATH() {

    if [ -z "$1" ]; then

        echo "ERROR: Directory is mandatory parameter"
        exit 1
    fi

    DIR_PATH="$1"

    # shellcheck disable=SC2002
    if ! cat "$FILE_RC" | grep "$DIR_PATH" >/dev/null 2>&1; then

        LINE_TO_ADD="export PATH=\${PATH}:$DIR_PATH"

        if echo "" >> "$FILE_RC" && echo "$LINE_TO_ADD" >> "$FILE_RC"; then

            echo "Module path '$DIR_PATH' is added into '$FILE_RC' configuration"
            
        else

            echo "WARNING: Module path '$DIR_PATH' was not added intp '$FILE_RC' configuration"
        fi
    fi
}

INIT_DIR() {

    if [ -z "$1" ]; then

        echo "ERROR: Direcotry path parameter is mandatory"
        exit 1
    fi

    DIRECTORY_PATH="$1"

    if ! test -e "$DIRECTORY_PATH"; then

        if ! mkdir -p "$DIRECTORY_PATH"; then

            echo "ERROR: Could not create directory '$DIRECTORY_PATH'"
            exit 1
        fi
    fi
}
