#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
DIR_RECIPES="$HERE/Recipes"

if test -e "$DIR_RECIPES"; then

    echo "Checking for the supported OS-es"

    for RECIPE in "$DIR_RECIPES"/*; do 

        if [ -f "$RECIPE" ]; then 
            
            echo "OS check recipe: '$RECIPE'"

            if sh "$RECIPE"; then

                exit 0
            fi

            echo "ERROR: No supported OS-es found"
            exit 1
        fi 
    done
else

    echo "WARNING: No OS-check recipes found at '$DIR_RECIPES'"
fi