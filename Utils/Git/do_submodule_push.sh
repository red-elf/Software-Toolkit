#!/bin/bash

DO_SUBMODULE() {

    if [ -z "$SESSION" ]; then

        echo "ERROR: No 'SESSION' defined"
        exit 1
    fi

    if [ -z "$SUBMODULES_HOME" ]; then

        echo "ERROR: The SUBMODULES_HOME is not defined"
        exit 1
    fi

    if [ -z "$1" ]; then

        echo "ERROR: Submodule name is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Submodule repo is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$3" ]; then

        echo "ERROR: Submodule path is mandatory parameter for the function"
        exit 1
    fi

    if [ -z "$4" ]; then

        echo "ERROR: Parent .submodule file path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$4"
    REPO="$2"
    SUBMODULE="$1"
    SUBMODULE_PATH="$3"
    DIR_PARENT="$(dirname "$FILE")"

    DIR_HOME=$(eval echo ~"$USER")
    FILE_ZSH_RC="$DIR_HOME/.zshrc"
    FILE_BASH_RC="$DIR_HOME/.bashrc"

    FILE_RC=""
        
    if test -e "$FILE_ZSH_RC"; then

        FILE_RC="$FILE_ZSH_RC"

    else

        if test -e "$FILE_BASH_RC"; then

        FILE_RC="$FILE_BASH_RC"

        else

        echo "ERROR: No '$FILE_ZSH_RC' or '$FILE_BASH_RC' found on the system"
        exit 1
        fi
    fi

    # shellcheck disable=SC1090
    . "$FILE_RC" >/dev/null 2>&1

    if [ -z "$SUBMODULES_HOME" ]; then

        echo "ERROR: The SUBMODULES_HOME is not defined"
        exit 1
    fi

    DIR_UPSTREAMABLE="$SUBMODULES_HOME/Upstreamable"
    SCRIPT_INSTALL_UPSTREAMS="$DIR_UPSTREAMABLE/install_upstreams.sh"
    SCRIPT_STRINGS="$SUBMODULES_HOME/Software-Toolkit/Utils/strings.sh"
    SCRIPT_PUSH_ALL="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/push_all.sh"

    if test -e "$SCRIPT_STRINGS"; then

        # shellcheck disable=SC1090
        . "$SCRIPT_STRINGS"

    else

        echo "ERROR: Script not found '$SCRIPT_STRINGS'"
        exit 1
    fi
    

    if ! test -e "$SCRIPT_PUSH_ALL"; then

        echo "ERROR: Script not found '$SCRIPT_PUSH_ALL'"
        exit 1
    fi

    if ! test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

        echo "ERROR: Script not found '$SCRIPT_INSTALL_UPSTREAMS'"
        exit 1
    fi

    if check_prefixes "$SUBMODULE_PATH" "$LOCATION"; then

        SUBMODULE_FULL_PATH="$SUBMODULE_PATH"

    else
    
        SUBMODULE_FULL_PATH="$DIR_PARENT/$SUBMODULE_PATH"
    fi

    SCRIPT_PUSH_ALL="$SUBMODULES_HOME/Upstreamable/push_all.sh"

    if test -e "$SCRIPT_PUSH_ALL"; then

        if ! sh "$SCRIPT_PUSH_ALL" "$UPSTREAMS"; then

            echo "ERROR: Push all failure"
            exit 1  
        fi

    else

        echo "ERROR: Script not found '$SCRIPT_PUSH_ALL'"
        exit 1
    fi
    
    NAME=$(echo "$REPO" | sed 's:.*/::' | grep -o -P '(?<=).*(?=.git)')
    
    if [ "$NAME" = "" ]; then

        NAME=$(echo "$REPO" | sed 's:.*/::' | grep -o -P '(?<=/).*(?=)')
    fi

    if [ "$NAME" = "" ]; then

        NAME=$(echo "$REPO" | grep -o -P '(?<=https:/).*' | sed 's:.*/::')
    fi

    if [ "$NAME" = "" ]; then

        echo "ERROR: No name obtained for repo '$REPO'"
        exit 1
    fi

    echo "Git submodule: Name='$NAME', Submodule='$SUBMODULE', Repo='$REPO', Path='$SUBMODULE_FULL_PATH'"

    if ! test -e "$SUBMODULE_FULL_PATH"; then

      echo "ERROR: Submodule full path does not exist '$SUBMODULE_FULL_PATH'"
      exit 1
    fi

    if cd "$SUBMODULE_FULL_PATH"; then

        echo "Entered directory: '$SUBMODULE_FULL_PATH'"

        # shellcheck disable=SC2012
        if [ "$(ls -1 | wc -l)" = "0" ]; then

            if git submodule init && git submodule update; then

                echo "Submodule (re) initialized at: '$SUBMODULE_FULL_PATH'"

            else

                echo "ERROR: Submodule initialization failed at '$SUBMODULE_FULL_PATH'"
                exit 1
            fi
        fi

        MAIN_BRANCH=""

        if git log -n 1 main | grep "commit " >/dev/null 2>&1; then

            MAIN_BRANCH="main"

        else

            if git log -n 1 master | grep "commit " >/dev/null 2>&1; then

            MAIN_BRANCH="master"

            fi
        fi

        if git checkout "$MAIN_BRANCH" >/dev/null 2>&1; then

            echo "'$MAIN_BRANCH' checked out at '$SUBMODULE_FULL_PATH'"

        else

            echo "ERROR: '$MAIN_BRANCH' failed to check out at '$SUBMODULE_FULL_PATH'"
            exit 1
        fi

        sh "$SCRIPT_INSTALL_UPSTREAMS" "$UPSTREAMS" >/dev/null 2>&1

        if git submodule init && git submodule update && git fetch && git config pull.rebase false && git pull; then

            echo "Submodule updated at '$SUBMODULE_FULL_PATH'"

        else

            echo "ERROR: Submodule failed to update at '$SUBMODULE_FULL_PATH'"
            exit 1
        fi

    else

        echo "ERROR: Could not enter directory '$SUBMODULE_FULL_PATH'"
        exit 1
    fi

    PUSH_ALL() {
        
        if [ -z "$1" ]; then

            echo "ERROR: The Upstreams argument is mandatory"
            exit 1
        fi

        UPSTREAMS="$1"

        if test -e "$UPSTREAMS"; then

            echo "We are about to push all the changes to remote upstreams"

        else

            echo "ERROR: Upstreams not found at '$UPSTREAMS'"
            exit 1
        fi

        if sh "$SCRIPT_PUSH_ALL" "$UPSTREAMS"; then

            echo "Push all at '$SUBMODULE_FULL_PATH'"

        else

            echo "ERROR: Failed to push at '$SUBMODULE_FULL_PATH'"
            exit 1
        fi
    }

    UPSTREAMS="$SUBMODULE_FULL_PATH/Upstreams"

    if git status | grep "Your branch is ahead of " | grep "by " | grep "commits." >/dev/null 2>&1; then

        PUSH_ALL "$UPSTREAMS"
    fi

    if git status | grep "Changes not staged for commit:" >/dev/null 2>&1 || \
        git status | grep "Changes to be committed:" >/dev/null 2>&1; then

        echo "We are going to commit and push changes at '$SUBMODULE_FULL_PATH'"

        if git add . >/dev/null 2>&1; then
        
            echo "Changes staged at '$SUBMODULE_FULL_PATH'"

            if git commit -m "Auto commit: $SESSION"; then

                echo "Changes have been commited at '$SUBMODULE_FULL_PATH'"

                PUSH_ALL "$UPSTREAMS"

            else

                echo "ERROR: Could not commit changes at '$SUBMODULE_FULL_PATH'"
                exit 1
            fi

        else

            echo "WARNING: Changes not staged at '$SUBMODULE_FULL_PATH'"
        fi
    fi

    if cd "$LOCATION"; then

        echo "Entered starting point directory: '$LOCATION'"

    else

        echo "ERROR: Could not enter starting point directory '$LOCATION'"
        exit 1
    fi
}
