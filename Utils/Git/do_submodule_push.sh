#!/bin/bash

DO_SUBMODULE() {

    if [ -z "$SESSION" ]; then

        echo "ERROR: No 'SESSION' defined"
        exit 1
    fi

    if [ -z "$SUBMODULES_HOME" ]; then

        echo "ERROR: The SUBMODULES_HOME is not defined"
        exit 1
    fi

    if [ -z "$1" ]; then

        echo "ERROR: Submodule name is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Submodule repo is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$3" ]; then

        echo "ERROR: Submodule path is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$4" ]; then

        echo "ERROR: Parent .submodule file path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$4"
    REPO="$2"
    SUBMODULE="$1"
    SUBMODULE_PATH="$3"
    DIR_PARENT="$(dirname "$FILE")"
    SUBMODULE_FULL_PATH="$DIR_PARENT/$SUBMODULE_PATH"

    SCRIPT_PUSH_ALL="$SUBMODULES_HOME/Upstreamable/push_all.sh"

    if ! test -e "$SCRIPT_PUSH_ALL"; then

        echo "ERROR: Script not found '$SCRIPT_PUSH_ALL'"
        exit 1
    fi
    
    NAME=$(echo "$REPO" | sed 's:.*/::' | grep -o -P '(?<=).*(?=.git)')
    
    if [ "$NAME" = "" ]; then

        NAME=$(echo "$REPO" | sed 's:.*/::' | grep -o -P '(?<=/).*(?=)')
    fi

    if [ "$NAME" = "" ]; then

        NAME=$(echo "$REPO" | grep -o -P '(?<=https:/).*' | sed 's:.*/::')
    fi

    if [ "$NAME" = "" ]; then

        echo "ERROR: No name obtained for repo '$REPO'"
        exit 1
    fi

    echo "Git submodule: Name='$NAME', Submodule='$SUBMODULE', Repo='$REPO', Path='$SUBMODULE_FULL_PATH'"

    if ! test -e "$SUBMODULE_FULL_PATH"; then

      echo "ERROR: Submodule full path does not exist '$SUBMODULE_FULL_PATH'"
      exit 1
    fi

    if cd "$SUBMODULE_FULL_PATH"; then

        echo "Entered directory: '$SUBMODULE_FULL_PATH'"

    else

        echo "ERROR: Could not enter directory '$SUBMODULE_FULL_PATH'"
        exit 1
    fi

    # TODO:
    
    git status

    if cd "$LOCATION"; then

        echo "Entered starting point directory: '$LOCATION'"

    else

        echo "ERROR: Could not enter starting point directory '$LOCATION'"
        exit 1
    fi
}