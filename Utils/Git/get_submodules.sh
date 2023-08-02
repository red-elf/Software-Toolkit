#!/bin/bash

LOCATION="$(pwd)"

if [ -n "$1" ]; then

    LOCATION="$1"
fi

echo "We are going to gather Git submodules information from: $LOCATION"

DO_FILE() {

    echo ">>> $1"
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE"
done;

echo "ERROR: Not yet implemented"
exit 1