#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_PATHS="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/paths.sh"

if ! test -e "$SCRIPT_PATHS"; then

    echo "ERROR: Script not found '$SCRIPT_PATHS'"
    exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_PATHS"

ADD_VARIABLE() {

    if [ -z "$1" ]; then

        echo "ERROR: Variable name is mandatory parameter"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Variable value is mandatory parameter"
        exit 1
    fi

    VARIABLE_NAME="$1"
    VARIABLE_VALUE="$2"
    
    LINE_TO_ADD="export $VARIABLE_NAME=\"$VARIABLE_VALUE\""

    # shellcheck disable=SC2002
    if cat "$FILE_RC" | grep "$VARIABLE_NAME=" >/dev/null 2>&1; then

        if cat "$FILE_RC" | grep "$LINE_TO_ADD" >/dev/null 2>&1; then

            echo "WARNING: Variable '$VARIABLE_NAME' is already present in '$FILE_RC' configuration"

        else

            # shellcheck disable=SC1090
            . "$FILE_RC"

            echo "ERROR: Entry '$VARIABLE_NAME' is already present in '$FILE_RC' configuration with different value from '$VARIABLE_VALUE'"
            exit 1
        fi

    else

        if echo "" >> "$FILE_RC" && echo "$LINE_TO_ADD" >> "$FILE_RC"; then

            echo "Variable '$VARIABLE_NAME' is added into '$FILE_RC' configuration: '$VARIABLE_VALUE'"
            
        else

            echo "ERROR: Variable '$VARIABLE_NAME' is not added into '$FILE_RC' configuration"
            exit 1
        fi
    fi
}
