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

LOAD_RCS() {

    LOAD_RC "$FILE_RC"
    LOAD_RC "$FILE_PTOOLKIT_RC"
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

        if cat "$PTOOLKIT_RC" | grep "$LINE_TO_ADD" >/dev/null 2>&1; then

            echo "WARNING: Line '$LINE_TO_ADD' is already present in the '$PTOOLKIT_RC'"

        else

            if ! echo "$LINE_TO_ADD" >> "$PTOOLKIT_RC"; then

                echo "ERROR: Variable '$VARIABLE_NAME' is not added into '$PTOOLKIT_RC' configuration"
                exit 1
            fi

            LOAD_RC "$PTOOLKIT_RC"
        fi
    fi
}

ADD_LINE_BREAK() {

    DEST_RC="$FILE_PTOOLKIT_RC"

    if [ -n "$1" ]; then

        DEST_RC="$1"
    fi

    if ! test -e "$DEST_RC"; then

        echo "ERROR: No '$DEST_RC' found on the system"
        exit 1
    fi

    echo "" >> "$DEST_RC"
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

    ADD_LINE "export $VARIABLE_NAME=\"$VARIABLE_VALUE\""
}
