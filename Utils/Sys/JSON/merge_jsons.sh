#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_GET_JQ="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_jq.sh"

if ! test -e "$SCRIPT_GET_JQ"; then

    echo "ERROR: Script not found '$SCRIPT_GET_JQ'"
    exit 1
fi

if [ -n "$1" ]; then

    SOURCE="$1"

    echo "Source JSON path: $SOURCE"

else

    echo "ERROR: The source JSON path is mandatory"
    exit 1
fi

if [ -n "$2" ]; then

    ADDITION="$2"

    echo "Addition JSON path: $ADDITION"

else

    echo "ERROR: The addition JSON path is mandatory"
    exit 1
fi

if [ -n "$3" ]; then

    DESTINATION="$3"

    echo "Destination path: $DESTINATION"

else

    echo "ERROR: The destination JSON path is mandatory"
    exit 1
fi

OBTAIN_CONTENT() {

    if [ -z "$1" ]; then

        echo "ERROR: Content file path is mandatory"
        exit 1
    fi

    FILE="$1"

    NAME=$(basename -- "$FILE")
    EXTENSION="${NAME##*.}"

    CONTENT=""

    if [ "$EXTENSION" = "json" ]; then

        CONTENT=$(cat "$FILE")
    fi

    if [ "$EXTENSION" = "sh" ]; then

        CONTENT=$(sh "$FILE")
    fi

    echo "$CONTENT"
}

SOURCE_CONTENT=$(OBTAIN_CONTENT "$SOURCE")
ADDITION_CONTENT=$(OBTAIN_CONTENT "$ADDITION")

echo "Source JSON content:"
echo "$SOURCE_CONTENT"

echo "Addition JSON content:"
echo "$ADDITION_CONTENT"

if sh "$SCRIPT_GET_JQ" >/dev/null 2>&1; then

    DESTINATION_CONTENT=$(echo "$SOURCE_CONTENT$ADDITION_CONTENT" | jq -s 'add')
    
    echo "Destination JSON content:"
    echo "$DESTINATION_CONTENT"

    if ! echo "$DESTINATION_CONTENT" > "$DESTINATION"; then

        echo "ERROR: Couldn't write into '$DESTINATION'"
        exit 1
    fi

else

    echo "ERROR: JQ not available"
    exit 1
fi

