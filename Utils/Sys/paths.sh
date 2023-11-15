#!/bin/bash

ADD_TO_PATH() {

    if [ -z "$1" ]; then

        echo "ERROR: RC file path is mandatory parameter"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Directory is mandatory parameter"
        exit 1
    fi

    FILE_RC="$1"
    DIR_PATH="$2"

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
