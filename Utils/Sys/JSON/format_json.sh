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

SESSION=$(($(date +%s%N)/1000000))
UNFORMATTED="$SOURCE.unformatted.$SESSION.bak"

cp "$SOURCE" "$UNFORMATTED"

# FIXME: 
#

# if cp "$SOURCE" "$UNFORMATTED"; then

#     if ! cat <<< jq '.' "$UNFORMATTED" > "$SOURCE"; then

#         echo "ERROR: Could not format JSON from '$SOURCE'"
#         exit 1
#     fi

# else

#     exit 1
# fi
