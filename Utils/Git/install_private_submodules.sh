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

cd "$DIR_RECIPES" && echo "Processing recipes from: '$DIR_RECIPES'"

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

    echo "Recipe '$NAME': $REPO"

    # TODO: Implement
}

for i in *.sh; do

    if test -e "$i"; then

        RECIPE_FILE="$(DIR_RECIPES)"/"$i"
        
        # shellcheck disable=SC1090
        echo "Processing the recipe file: $RECIPE_FILE" && . "$RECIPE_FILE"

        PROCESS_RECIPE "$NAME" "$REPO"

    else

        echo "WARNING: Upstreams not found at '$DIR_UPSTREAMS'"
        exit 0
    fi
done

if cd "$HERE" && echo "Private submodules installation completed"; then

    echo "We are back to '$HERE'"

else

    echo "ERROR: Gould not get back to '$HERE'"
    exit 1
fi