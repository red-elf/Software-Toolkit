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

LOAD_RC() {

    if [ -z "$FILE_RC" ]; then

        echo "ERROR: '$FILE_RC' variable is not defined"
        exit 1
    fi

    # shellcheck disable=SC1090
    if source "$FILE_RC"; then

        echo "The RC file loaded '$FILE_RC' by 'source'"

    else

        if . "$FILE_RC"; then

            echo "The RC file loaded '$FILE_RC' by '.'"

        else

            echo "ERROR: Could not load the RC file '$FILE_RC'"
            exit 1
        fi
    fi
}

ADD_LINE() {

    if [ -z "$1" ]; then

        echo "ERROR: VariableLine to ad is mandatory parameter"
        exit 1
    fi

    LINE_TO_ADD="$1"

    # shellcheck disable=SC2002
    if cat "$FILE_RC" | grep "$LINE_TO_ADD" >/dev/null 2>&1; then

        echo "WARNING: Line '$LINE_TO_ADD' is already present in the '$FILE_RC'"

    else

        if echo "$LINE_TO_ADD" >> "$FILE_RC"; then

            echo "Variable '$VARIABLE_NAME' is added into '$FILE_RC' configuration: '$VARIABLE_VALUE'"
            
        else

            echo "ERROR: Variable '$VARIABLE_NAME' is not added into '$FILE_RC' configuration"
            exit 1
        fi

        LOAD_RC
    fi
}

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

    ADD_LINE "$VARIABLE_NAME=\"$VARIABLE_VALUE\""
    ADD_LINE "export $VARIABLE_NAME"
}
