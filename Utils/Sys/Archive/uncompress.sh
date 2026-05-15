#!/bin/bash

UNCOMPRESS() {

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

    echo "Uncompressing '$WHAT' into '$WHERE'"

    # TODO: Implement uncompressing for tar.gz and zip both
    #
    # if ! tar -cjf "$WHERE" -C "$WHAT" .; then

    #     echo "ERROR: uncompressing '$WHAT' into '$WHERE' has failed"
    #     exit 1
    # fi
}