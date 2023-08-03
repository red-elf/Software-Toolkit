#!/bin/bash

LOCATION="$(pwd)"

if [ -n "$1" ]; then

    LOCATION="$1"
fi

echo "We are going to gather Git submodules information from: $LOCATION"

check_prefixes () {
    value=$1
    shift

    for prefix do
        case $value in
            "$prefix"*) return 0
        esac
    done

    return 1
}

check_contains () {
    value=$1
    shift

    case $value in
        *"$1"*) return 0
    esac

    return 1
}

DO_SUBMODULE() {

    if [ -z "$1" ]; then

        echo "ERROR: Submodule name is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Submodule repo is mandatory parameter for the function"
        exit 1
    fi

    SUBMODULE="$1"
    REPO="$2"
    
    echo "Processing Git submodule '$SUBMODULE': $REPO"
}

DO_FILE() {

    if [ -z "$1" ]; then

        echo "ERROR: File path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$1"
    
    echo "Processing Git modules file: $FILE"

    REPO=""
    SUBMODULE=""    
    SUBMODULE_OPENING="[submodule"
    
    CONTENT=$(cat "$FILE")

    IFS=$'\n'

    for ITEM in $CONTENT; do

        if check_prefixes "$ITEM" "$SUBMODULE_OPENING"; then

            echo ">>>> $ITEM"

        else

            echo ">> $ITEM" 
        fi
    done;
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE"
done;
