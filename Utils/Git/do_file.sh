#!/bin/bash

DO_FILE() {

    if [ -z "$SUBMODULES_HOME" ]; then

        echo "ERROR: The SUBMODULES_HOME is not defined"
        exit 1
    fi

    SCRIPT_STRINGS="$SUBMODULES_HOME/Software-Toolkit/Utils/strings.sh"
    SCRIPT_DO_SUBMODULE="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/do_submodule.sh"

    if test -e "$SCRIPT_STRINGS"; then

        # shellcheck disable=SC1090
        . "$SCRIPT_STRINGS"

    else

        echo "ERROR: Script not found '$SCRIPT_STRINGS'"
        exit 1
    fi

    if test -e "$SCRIPT_DO_SUBMODULE"; then

        # shellcheck disable=SC1090
        . "$SCRIPT_DO_SUBMODULE"

    else

        echo "ERROR: Script not found '$SCRIPT_DO_SUBMODULE'"
        exit 1
    fi

    if [ -z "$1" ]; then

        echo "ERROR: File path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$1"
    
    echo "Git modules file: $FILE"

    REPO=""
    SUBMODULE=""
    SUBMODULE_PATH=""
    
    SUBMODULE_OPENING="[submodule"
    SUBMODULE_URL_MARK="url = "
    SUBMODULE_PATH_MARK="path = "
    
    CONTENT=$(cat "$FILE")

    IFS=$'\n'

    for ITEM in $CONTENT; do

        if [ ! "$ITEM" = ""  ]; then

            if check_prefixes "$ITEM" "$SUBMODULE_OPENING"; then

                SUBMODULE=$(echo "$ITEM" | grep -o -P '(?<=").*(?=")')
            fi

            if check_contains "$ITEM" "$SUBMODULE_URL_MARK"; then

                REPO=$(echo "$ITEM" | grep -o -P '(?<=url = ).*(?=)')
            fi

            if check_contains "$ITEM" "$SUBMODULE_PATH_MARK"; then

                SUBMODULE_PATH=$(echo "$ITEM" | grep -o -P '(?<=path = ).*(?=)')
            fi

            if [ ! "$SUBMODULE" = "" ] && [ ! "$REPO" = "" ] && [ ! "$SUBMODULE_PATH" = "" ]; then

                DO_SUBMODULE "$SUBMODULE" "$REPO" "$SUBMODULE_PATH" "$FILE"

                REPO=""
                SUBMODULE=""
                SUBMODULE_PATH=""
            fi
        fi
    done;
}