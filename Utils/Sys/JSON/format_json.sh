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

    if ! test -e "$SOURCE"; then

        echo "ERROR: Source JSON file does not exits '$SOURCE'"
        exit 1
    fi

else

    echo "ERROR: The source JSON path is mandatory"
    exit 1
fi

CONTENT=$(cat "$SOURCE")
DIR_PARENT="$(dirname "$SOURCE")"
FILE_NAME=$(basename -- "$SOURCE")
FORMATTED="Formatted.$FILE_NAME"
FORMATTED_PATH="$DIR_PARENT/$FORMATTED"

if [ "$CONTENT" = "" ]; then

    echo "ERROR: No content (1)"
    exit 1
fi

CONTENT=$(echo "$CONTENT" | jq)

if [ "$CONTENT" = "" ]; then

    echo "ERROR: No content (2)"
    exit 1
fi

if echo "$CONTENT" > "$FORMATTED_PATH"; then

    echo "$FORMATTED_PATH"

else

    echo "ERROR: Could not save formatted JSON content to '$SOURCE'"
    exit 1
fi
