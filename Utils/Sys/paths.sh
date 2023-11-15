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