#!/bin/bash

if [ -n "$1" ]; then

    RECIPE="$1"

    echo "Recipe path: $RECIPE"

else

    echo "ERROR: The recipe path is mandatory"
    exit 1
fi

RECIPE_CONTENT=$(sh "$RECIPE")

echo "Recipe content:"
echo "$RECIPE_CONTENT"

