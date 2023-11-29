#!/bin/bash

HERE="$(pwd)"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_LINK="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Filesystem/link.sh"

if ! test -e "$SCRIPT_LINK"; then

  echo "ERROR: Script not found '$SCRIPT_LINK'"
  exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_LINK"

if [ -z "$1" ]; then

    echo "ERROR: Private modules home directory parameter is mandatory"
    exit 1
fi

if [ -z "$2" ]; then

    echo "ERROR: Private modules recipes directory parameter is mandatory"
    exit 1
fi

DIR_MODULES_HOME="$1"
DIR_RECIPES="$2"

echo "Checking and installing private modules from '$DIR_RECIPES' into '$DIR_MODULES_HOME'"

PROCESS_RECIPE() {

    if [ -z "$1" ]; then

        echo "ERROR: Name parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Repo parameter is mandatory"
        exit 1
    fi

    NAME="$1"
    REPO="$2"

    echo "Recipe for '$NAME' from '$REPO'"

    DIR_INSTALL_TO="$DIR_MODULES_HOME/$NAME"

    DO_CLONE() {

        if git clone --recurse-submodules "$REPO" "$DIR_INSTALL_TO"; then

            echo "Clone completed"

            DIR_PRIVATE="$HERE/_Private"

            if ! test -e "$DIR_PRIVATE"; then

                if ! mkdir -p "$DIR_PRIVATE"; then

                    echo "ERROR: Could not create directory '$DIR_PRIVATE'"
                    exit 1
                fi
            fi

            LINK_FILE_TO_DESTINATION "$DIR_INSTALL_TO" "$DIR_PRIVATE/$NAME"

        else

            echo "ERROR: Clone failed"
            exit 1
        fi
    }

    if test -e "$DIR_INSTALL_TO"; then

        echo "SKIPPING: Directory already exists '$DIR_INSTALL_TO'"

    else

        if ! mkdir -p "$DIR_INSTALL_TO"; then

            echo "ERROR: Could not create directory '$DIR_INSTALL_TO'"
            exit 1
        fi

        DO_CLONE
    fi
}

cd "$DIR_RECIPES" && echo "Processing recipes from: '$DIR_RECIPES'"

for i in *.submodule; do

    RECIPE_FILE="$DIR_RECIPES"/"$i"

    if test -e "$RECIPE_FILE"; then

        # shellcheck disable=SC1090
        echo "Processing the recipe file: $RECIPE_FILE" && . "$RECIPE_FILE"

        PROCESS_RECIPE "$NAME" "$REPO"

    else

        echo "WARNING: Recipe not found '$RECIPE_FILE'"
        exit 0
    fi
done

if cd "$HERE" && echo "Private submodules installation completed"; then

    echo "We are back to '$HERE'"

else

    echo "ERROR: Gould not get back to '$HERE'"
    exit 1
fi