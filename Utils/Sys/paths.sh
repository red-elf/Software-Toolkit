#!/bin/bash

FILE_RC=""
DIR_HOME=$(eval echo ~"$USER")

export FILE_ZSH_RC="$DIR_HOME/.zshrc"
export FILE_BASH_RC="$DIR_HOME/.bashrc"
export FILE_PTOOLKIT_RC="$DIR_HOME/.ptoolkitrc"

if ! test -e "$FILE_PTOOLKIT_RC"; then

    if ! touch "$FILE_PTOOLKIT_RC"; then

        echo "ERROR: Could not create '$FILE_PTOOLKIT_RC'"
        exit 1
    fi
fi

if test -e "$FILE_PTOOLKIT_RC"; then

    CONTENT_TO_ADD="#!/bin/bash

if [ -z \"\$SUBMODULES_HOME\" ]; then

  echo \"ERROR: 'SUBMODULES_HOME' not available\"
  exit 1
fi

SCRIPT_PATHS=\"\$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/environment.sh\"

if ! test -e \"\$SCRIPT_PATHS\"; then

    echo \"ERROR: Script not found '\$SCRIPT_PATHS'\"
    exit 1
fi

# shellcheck disable=SC1090
if ! source \"\$SCRIPT_PATHS\"; then

    if ! . \"\$SCRIPT_PATHS\"; then

        echo \"ERROR: Could not load '\$SCRIPT_PATHS'\"
        exit 1
    fi
fi
"

    # shellcheck disable=SC2002
    if ! cat "$FILE_PTOOLKIT_RC" | grep "$CONTENT_TO_ADD" >/dev/null 2>&1; then

        if ! echo "$CONTENT_TO_ADD" > "$FILE_PTOOLKIT_RC"; then

            echo "ERROR: Could not add '$CONTENT_TO_ADD' into '$FILE_PTOOLKIT_RC'"
            exit 1
        fi
    fi

else

    echo "ERROR: No '$FILE_PTOOLKIT_RC' found on the system"
    exit 1
fi

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

LINE_TO_ADD="source $FILE_PTOOLKIT_RC"

# shellcheck disable=SC2002
if cat "$FILE_RC" | grep "$LINE_TO_ADD" >/dev/null 2>&1; then

    echo "'$LINE_TO_ADD' is already configured in '$FILE_RC'"

else

    if ! echo "$LINE_TO_ADD" >> "$FILE_RC"; then

        echo "ERROR: Could not add '$LINE_TO_ADD' into '$FILE_RC'"
        exit 1
    fi
fi

export FILE_RC
export DIR_HOME
export FILE_PTOOLKIT_RC

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

LOAD() {

    if [ -z "$1" ]; then

        echo "ERROR: Script to load is mandatory parameter"
        exit 1
    fi

    TO_LOAD="$1"

    if ! test -e "$TO_LOAD"; then

        echo "ERROR: Script not found '$TO_LOAD'"
        exist 1
    fi

    # shellcheck disable=SC1090
    if ! source "$TO_LOAD"; then

        if ! . "$TO_LOAD"; then

            echo "ERROR: Could not load '$TO_LOAD'"
            exit 1
        fi
    fi
}

LOAD_RC() {

    if [ -n "$1" ]; then

        FILE_RC="$1"
    fi

    if [ -z "$FILE_RC" ]; then

        echo "ERROR: '$FILE_RC' variable is not defined"
        exit 1
    fi

    LOAD "$FILE_RC"   
}

TRANSFORM_INTO_PATH() {

    # Dependency example:
    #
    # Software-Toolkit/Utils/Sys/paths
    #

    if [ -z "$1" ]; then

        echo "ERROR: Dependency is mandatory parameter"
        exit 1
    fi

    if [ "$1" = "" ]; then

        echo "ERROR: Dependency is empty"
        exit 1
    fi

    if [ -z "${1%%/*}" ] && pathchk -pP "$1" >/dev/null 2>&1; then

        DEPENDENCY_TO_TRANSFORM="$1"

    else

        if [ -z "$SUBMODULES_HOME" ]; then

            echo "ERROR: 'SUBMODULES_HOME' not available"
            exit 1
        fi

        DEPENDENCY_TO_TRANSFORM="$SUBMODULES_HOME/$1"
    fi

    if ! test -e "$DEPENDENCY_TO_TRANSFORM"; then

        DEPENDENCY_TO_TRANSFORM="$DEPENDENCIES_TO_TRANSFORM.sh"
    fi

    if ! test -e "$DEPENDENCY_TO_TRANSFORM"; then

        echo "ERROR: Dependency not found '$DEPENDENCY_TO_TRANSFORM'"
        exit 1
    fi

    echo "$DEPENDENCY_TO_TRANSFORM"
}

IMPORT() {

    if [ -z "$1" ]; then

        echo "ERROR: Dependency to import is mandatory parameter"
        exit 1
    fi

    TO_IMPORT="$1"
    TO_IMPORT=$(TRANSFORM_INTO_PATH "$TO_IMPORT")

    if ! test -e "$TO_IMPORT"; then

        echo "ERROR: Dependency not found '$TO_IMPORT'"
        exit 1
    fi

    echo "$TO_IMPORT"
}

USE() {

    if [ -z "$1" ]; then

        echo "ERROR: Dependency to use is mandatory parameter"
        exit 1
    fi

    TO_USE=$(IMPORT "$1")

    if [ -z "$TO_USE" ] || ! test -e "$TO_USE"; then

        echo "ERROR: Could not use dependency '$1'"
        exit 1
    fi

    LOAD "$TO_USE"
}
