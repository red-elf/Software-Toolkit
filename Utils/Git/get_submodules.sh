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
    echo "Processing Git modules file: $1"
    
    CONTENT="$(cat $FILE)"

    echo ">>> $CONTENT"
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE"
done;
