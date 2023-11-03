#!/bin/bash

HERE="$(pwd)"

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

    # TODO: Implement
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