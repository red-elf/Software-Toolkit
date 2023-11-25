#!/bin/bash

COMPRESS() {

    if [ -z "$1" ]; then

        echo "ERROR: The 'WHAT' parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: The 'WHERE' parameter is mandatory"
        exit 1
    fi

    WHAT="$1"
    WHERE="$2"

    echo "Compressing '$WHAT' into '$WHERE'"

    if ! tar -cjf "$WHERE" -C "$WHAT" .; then

        echo "ERROR: compressing '$WHAT' into '$WHERE' has failed"
        exit 1
    fi
}