#!/bin/bash

DO_SUBMODULE() {

    if [ -z "$SUBMODULES_HOME" ]; then

        echo "ERROR: The SUBMODULES_HOME is not defined"
        exit 1
    fi

    SCRIPT_DO_UPDATE="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/do_update.sh"

    if test -e "$SCRIPT_DO_UPDATE"; then

        # shellcheck disable=SC1090
        . "$SCRIPT_DO_UPDATE" >/dev/null 2>&1

    else

        echo "ERROR: Script not found '$SCRIPT_DO_UPDATE'"
        exit 1
    fi

    if [ -z "$LOCATION" ]; then

        LOCATION="$(pwd)"
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

    DIR_DESTINATION="$DIR_SUBMODULES_FULL/$NAME"

    FILE_NAME="$NAME.submodule"
    FILE_NAME_FULL="$DIR_SUBMODULES_FULL/$FILE_NAME"

    APSOLUTE_SUBMOPDULE_PATH="$DIR_PARENT/$SUBMODULE_PATH"
    
    echo "Git submodule: Name='$NAME', Submodule='$SUBMODULE', Repo='$REPO', Path='$SUBMODULE_PATH'"

    if CHECK_PREFIXES "$SUBMODULE_PATH" "$DIR_SUBMODULES_FULL"; then

        echo "SKIPPING: Git submodule path '$SUBMODULE_PATH'"

    else

        if test -e "$APSOLUTE_SUBMOPDULE_PATH"; then

            if cd "$APSOLUTE_SUBMOPDULE_PATH"; then

                echo "Entered directory (1): '$APSOLUTE_SUBMOPDULE_PATH'"

                MAIN_BRANCH=""

                if git log -n 1 main | grep "commit " >/dev/null 2>&1; then

                    MAIN_BRANCH="main"

                else

                    MAIN_BRANCH="master"
                fi
                
                SYM_HEAD="$(git symbolic-ref HEAD)"

                if echo "$SYM_HEAD" | grep "fatal:"; then

                    excho "ERROR: Git failure at '$APSOLUTE_SUBMOPDULE_PATH'"
                    exit 1
                fi

                if echo "$SYM_HEAD" | grep "refs/heads/$MAIN_BRANCH" >/dev/null 2>&1; then

                    if ! test -e "$FILE_NAME_FULL"; then

                        if ! touch "$FILE_NAME_FULL"; then

                            echo "ERROR: Could not create file '$FILE_NAME'"
                            exit 1
                        fi

                        cat > "$FILE_NAME_FULL" <<EOL
#!/bin/bash

NAME="$NAME"
REPO="$REPO"
EOL

                        echo "Git submodule file has been written: $FILE_NAME_FULL"

                    fi

                    echo "Pointing Git submodule: $APSOLUTE_SUBMOPDULE_PATH into $DIR_DESTINATION"

                    if test -e "$DIR_DESTINATION"; then

                        echo "Git submodule repository '$REPO' already initialized in '$DIR_DESTINATION'"

                    else

                        echo "Git submodule repository '$REPO' will be initialized into '$DIR_DESTINATION'"

                        if git submodule add "$REPO" "$DIR_DESTINATION"; then

                            if cd "$DIR_DESTINATION" && git config pull.rebase false && cd "$LOCATION"; then

                                echo "Git merging strategy set for: '$DIR_DESTINATION'"

                            else

                                echo "ERROR: Could not set Git merging strategy for '$DIR_DESTINATION'"
                                exit 1
                            fi

                            if git submodule init && git submodule update; then

                                echo "Submodule (re) initialized at: '$SUBMODULE_FULL_PATH'"

                            else

                                echo "ERROR: Submodule initialization failed at '$SUBMODULE_FULL_PATH'"
                                exit 1
                            fi

                            echo "Git submodule repository '$REPO' has been initialized into '$DIR_DESTINATION'"

                            DIR_UPSTREAMS="$DIR_DESTINATION/Upstreams"

                            if test -e "$DIR_UPSTREAMS"; then

                                echo "Bringing up Upstreams from '$DIR_UPSTREAMS'"

                                DIR_UPSTREAMABLE="$LOCATION/Upstreamable"
                                SCRIPT_INSTALL_UPSTREAMS="$DIR_UPSTREAMABLE/install_upstreams.sh"

                                if test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

                                    bash "$SCRIPT_INSTALL_UPSTREAMS" "$DIR_UPSTREAMS"

                                else

                                    echo "ERROR: Script not found '$SCRIPT_INSTALL_UPSTREAMS'"
                                    exit 1
                                fi
                            fi

                        else

                            echo "ERROR: Git submodule repository '$REPO' has failed to initialize into '$DIR_DESTINATION'"
                            exit 1
                        fi
                    fi

                    if cd "$LOCATION"; then

                        echo "Entered starting point directory (2): '$LOCATION'"

                    else

                        echo "ERROR: Could not enter starting point directory (2) '$LOCATION'"
                        exit 1
                    fi

                else

                    echo "SKIPPING: Git submodule from '$APSOLUTE_SUBMOPDULE_PATH' does not point to the main branch"

                    if cd "$LOCATION"; then

                        echo "Entered starting point directory: '$LOCATION'"

                    else

                        echo "ERROR: Could not enter starting point directory '$LOCATION'"
                        exit 1
                    fi
                fi

            else

                echo "ERROR: Could not enter directory (1) '$APSOLUTE_SUBMOPDULE_PATH'"
                exit 1
            fi

        else

            echo "ERROR: Submodule path does not exist '$APSOLUTE_SUBMOPDULE_PATH'"
            exit 1
        fi
    fi

    DO_UPDATE "$APSOLUTE_SUBMOPDULE_PATH"
    DO_UPDATE "$DIR_DESTINATION"

    if cd "$LOCATION"; then

        echo "Entered starting point directory (3): '$LOCATION'"

    else

        echo "ERROR: Could not enter starting point directory (3) '$LOCATION'"
        exit 1
    fi
}