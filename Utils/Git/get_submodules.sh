#!/bin/bash

LOCATION="$(pwd)"

if [ -n "$1" ]; then

    LOCATION="$1"
fi

echo "We are going to gather Git submodules information from: $LOCATION"

DO_FILE() {

    if [ -z "$1" ]; then

        echo "ERROR: File path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$1"
    
    echo "Processing Git modules file: $FILE"
    
    CONTENT=$(cat "$FILE")

    # TODO: Parsing
    echo "$CONTENT" | awk '{split($0, a, /=/); split(a[1], b, /\./); print b[0], b[2], b[3], a[2]}'
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE"
done;
