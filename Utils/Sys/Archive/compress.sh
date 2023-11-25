#!/bin/bash

COMPRESS() {

    HERE="$(pwd)"

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

    # DIR_WHAT=$(dirname -- "$WHAT")

    echo "Compressing '$WHAT' into '$WHERE'"

    if tar -cjf "$WHERE" -C "$WHAT" .; then

        cd "$HERE" && echo "Compressing '$WHAT' into '$WHERE' has completed"

    else

        echo "ERROR: compressing '$WHAT' into '$WHERE' has failed"
        exit 1
    fi
}