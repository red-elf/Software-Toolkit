#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_GET_JQ="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_jq.sh"
SCRIPT_FORMAT_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/JSON/format_json.sh"

if ! test -e "$SCRIPT_GET_JQ"; then

    echo "ERROR: Script not found '$SCRIPT_GET_JQ'"
    exit 1
fi

if ! test -e "$SCRIPT_FORMAT_JSON"; then

    echo "ERROR: Script not found '$SCRIPT_FORMAT_JSON'"
    exit 1
fi

if [ -n "$1" ]; then

    SOURCE="$1"

    echo "JSON path :: SOURCE: $SOURCE"

else

    echo "ERROR: The source JSON path is mandatory"
    exit 1
fi

if [ -n "$2" ]; then

    ADDITION="$2"

    echo "JSON path :: ADDING: $ADDITION"

else

    echo "ERROR: The addition JSON path is mandatory"
    exit 1
fi

if [ -n "$3" ]; then

    DESTINATION="$3"

    echo "JSON path :: DESTIN: $DESTINATION"

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
    CONTENT=""
    NAME=$(basename -- "$FILE")
    DIR_PARENT="$(dirname "$FILE")"
    EXTENSION="${NAME##*.}"

    if [ "$EXTENSION" = "json" ]; then

        CONTENT=$(cat "$FILE")
    fi

    if [ "$EXTENSION" = "sh" ]; then

        CONTENT=$(bash "$FILE")
    fi

    SESSION=$(($(date +%s%N)/1000000))
    NEW_FILE_PATH="$DIR_PARENT/$SESSION.json"

    if echo "$CONTENT" > "$NEW_FILE_PATH"; then

        if ! test -e "$NEW_FILE_PATH"; then

            echo "ERROR: Could not create tmp. file '$NEW_FILE_PATH' (2)"
            exit 1
        fi

        SAVED_FILE=$(bash "$SCRIPT_FORMAT_JSON" "$NEW_FILE_PATH")

        if test -e "$SAVED_FILE"; then

            cat "$SAVED_FILE"
                
            rm -f "$SAVED_FILE" >/dev/null 2>&1
            rm -f "$NEW_FILE_PATH" >/dev/null 2>&1
                
        else

            rm -f "$NEW_FILE_PATH" && echo "ERROR: No saved file '$SAVED_FILE'"
            exit 1
        fi

    else

        echo "ERROR: Could not create tmp. file '$NEW_FILE_PATH' (1)"
        exit 1
    fi
}

SOURCE_CONTENT=$(OBTAIN_CONTENT "$SOURCE")
ADDITION_CONTENT=$(OBTAIN_CONTENT "$ADDITION")

echo "JSON content :: Source:"
echo "$SOURCE_CONTENT"

echo "JSON content :: Adding:"
echo "$ADDITION_CONTENT"

if bash "$SCRIPT_GET_JQ" >/dev/null 2>&1; then

    DESTINATION_CONTENT=$(echo "$SOURCE_CONTENT$ADDITION_CONTENT" | jq -s 'add')
    
    echo "JSON content :: Merged:"
    echo "$DESTINATION_CONTENT"

    EXISTING_CONTENT=$(cat "$DESTINATION")

    if [ "$EXISTING_CONTENT" = "$DESTINATION_CONTENT" ]; then

        echo "No changes to be written into '$DESTINATION'"

    else

        if test -e "$DESTINATION"; then

            SUFIX=$(($(date +%s%N)/1000000))

            if ! cp "$DESTINATION" "$DESTINATION.$SUFIX.bak"; then

                echo "ERROR: Could not create a backup of '$DESTINATION'"
                exit 1
            fi
        fi

        if echo "$DESTINATION_CONTENT" > "$DESTINATION"; then

            echo "Merged JSON has been written into '$DESTINATION'"

        else

            echo "ERROR: No merged JSON has been written into '$DESTINATION'"
            exit 1
        fi
    fi

else

    echo "ERROR: JQ not available"
    exit 1
fi

