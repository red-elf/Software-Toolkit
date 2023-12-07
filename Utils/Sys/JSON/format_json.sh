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

    if ! test -e "$SOURCE"; then

        echo "ERROR: Source JSON file does not exits '$SOURCE'"
        exit 1
    fi

else

    echo "ERROR: The source JSON path is mandatory"
    exit 1
fi

CONTENT=$(cat "$SOURCE")
FORMATTED="Formatted.$SOURCE"

if [ "$CONTENT" = "" ]; then

    echo "ERROR: No content (1)"
    exit 1
fi

CONTENT=$(jq <<< echo "$CONTENT")

if [ "$CONTENT" = "" ]; then

    echo "ERROR: No content (2)"
    exit 1
fi

if echo "$CONTENT" > "$FORMATTED"; then

    echo "$FORMATTED"

else

    echo "ERROR: Could not save formatted JSON content to '$SOURCE'"
    exit 1
fi
