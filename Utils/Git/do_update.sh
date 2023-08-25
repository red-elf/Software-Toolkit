#!/bin/bash

DO_UPDATE() {

    if [ -z "$LOCATION" ]; then

        LOCATION="$(pwd)"
    fi

    if [ -z "$1" ]; then

        echo "ERROR: Absoulte repository path parameter is mandatory"
        exit 1
    fi

    DIR_REPOSITORY="$1"

    if cd "$DIR_REPOSITORY"; then

        echo "Entered directory (2): '$DIR_REPOSITORY'"

    else

        echo "ERROR: Could not enter directory (2) '$DIR_REPOSITORY'"
        exit 1
    fi

    if [ -n "$2" ]; then

        BRANCH="$2"

    else

        if git log -n 1 main | grep "commit "; then

            BRANCH="main"

        else

            BRANCH="master"
        fi
    fi

    if [ -z "$1" ]; then

        echo "ERROR: Absoulte repository path parameter is mandatory"
        exit 1
    fi

    if cd "$DIR_REPOSITORY"; then

        echo "Entered directory (2): '$DIR_REPOSITORY'"

    else

        echo "ERROR: Could not enter directory (2) '$DIR_REPOSITORY'"
        exit 1
    fi

    if [ -n "$2" ]; then

        BRANCH="$2"

    else

        if git log -n 1 main | grep "commit "; then

            BRANCH="main"

        else

            BRANCH="master"
        fi
    fi

    echo "We are about to checkout branch: '$BRANCH' at '$DIR_REPOSITORY'"

    if git checkout "$BRANCH" && git fetch; then

        echo "We have checked out branch: '$BRANCH' at '$DIR_REPOSITORY'"

        CURRENT_COMMIT=$(git rev-parse HEAD)
        LAST_MAIN_COMMIT=$(git log -n 1 "origin/$BRANCH" | grep "commit ")
        LAST_MAIN_COMMIT=$(echo "$LAST_MAIN_COMMIT" | grep -o -P '(?<=commit ).*(?=)')

        if [ "$CURRENT_COMMIT" = "$LAST_MAIN_COMMIT" ]; then

            echo "Branch '$BRANCH' is already at the latest commit: $CURRENT_COMMIT"

        else

            if git pull && git config pull.rebase false; then

                echo "Branch '$BRANCH' updated at: '$DIR_REPOSITORY'"

            else

                echo "ERROR: Failed to update '$BRANCH' branch at '$DIR_REPOSITORY'"
                exit 1
            fi

        fi

    else

        echo "ERROR: Failed to set the '$BRANCH' branch at '$DIR_REPOSITORY'"
        exit 1
    fi

    if cd "$LOCATION"; then

        echo "Entered starting point directory (3): '$LOCATION'"

    else

        echo "ERROR: Could not enter starting point directory (3) '$LOCATION'"
        exit 1
    fi
}