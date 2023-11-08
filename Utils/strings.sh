#!/bin/bash

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

TRIM_LINES() {

    if [ -z "$1" ]; then

        echo "ERROR: File parameter is mandatoy"
        exit 1
    fi

    FILE_TO_TRIM="$1"

    echo "Trimming: $FILE_TO_TRIM"

    FILE_TMP="$FILE_TO_TRIM.tmp"

    if cp "$FILE_TO_TRIM" "$FILE_TMP"; then

        echo "Working file created: $FILE_TMP"

    else

        echo "ERROR: Could not create tmp file '$FILE_TMP'"
        exit 1
    fi
    
    TMP_CONTENT=$(cat "$FILE_TMP")

    if [ "$TMP_CONTENT" = "" ]; then

        echo "ERROR: Empty working file: $FILE_TMP"
        exit 1

    else

        # TODO: Do trim

        CONTENT=$(cat "$FILE_TO_TRIM")

        if [ "$TMP_CONTENT" = "$CONTENT" ]; then

            echo "No changes in content"

        else

            SUFIX=$(($(date +%s%N)/1000000))

            if ! cp "$FILE_TO_TRIM" "$FILE_TO_TRIM.$SUFIX.bak"; then

                echo "ERROR: Could not create a backup of '$FILE_TO_TRIM'"
                exit 1
            fi

            if echo "$TMP_CONTENT" > "$FILE_TO_TRIM"; then

                echo "Changes have been applied to '$FILE_TO_TRIM'"

            else

                echo "ERROR: Failed to apply changes to '$FILE_TO_TRIM'"
                exit 1
            fi

        fi

        if rm -f "$FILE_TMP"; then

            echo "Tmp file removed: '$FILE_TMP'"

        else

            echo "ERROR: Tmp file was not removed '$FILE_TMP'"
            exit 1
        fi
    fi
}