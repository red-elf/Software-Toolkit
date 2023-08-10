#!/bin/bash

UPDATED=""
LOCATION="$(pwd)"
DIR_SUBMODULES="_Submodules"
DIR_SUBMODULES_FULL="$LOCATION/$DIR_SUBMODULES"

if [ -n "$1" ]; then

    LOCATION="$1"
fi

echo "We are going to gather Git submodules information from: $LOCATION"

if ! test -e "$DIR_SUBMODULES_FULL"; then

    if ! mkdir -p "$DIR_SUBMODULES_FULL"; then

        echo "ERROR: Could not create directory '$DIR_SUBMODULES_FULL'"
        exit 1
    fi
fi

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
    
    echo "Git submodule: Name='$NAME', Submodule='$SUBMODULE', Repo='$REPO', Path='$SUBMODULE_PATH'"

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

    APSOLUTE_SUBMOPDULE_PATH="$DIR_PARENT/$SUBMODULE_PATH"

    if check_prefixes "$SUBMODULE_PATH" "$DIR_SUBMODULES_FULL"; then

        echo "SKIPPING: Git submodule path '$SUBMODULE_PATH'"

    else

        if test -e "$APSOLUTE_SUBMOPDULE_PATH"; then

            # TODO: Do not connect _Dependencies submodules if they are not targeting the main branch:
            # 
            # - When on tag:    HEAD detached at
            # - When on btanch: On branch
        
            echo "Pointing Git submodule: $APSOLUTE_SUBMOPDULE_PATH into $DIR_DESTINATION"

            if test -e "$DIR_DESTINATION"; then

                if cd "$DIR_DESTINATION" && \
                    echo "Git submodule repository '$REPO' already initialized in '$DIR_DESTINATION'"; then

                    echo "Entered directory: '$DIR_DESTINATION'"

                else

                    echo "ERROR: Could not enter directory '$DIR_DESTINATION'"
                    exit 1
                fi

                if check_contains "$UPDATED" "$DIR_DESTINATION;"; then

                    echo "SKIPPING: Already recently set to the main branch at '$DIR_DESTINATION' (and updated if it was needed)"

                else

                    if git checkout main || git checkout master; then

                        echo "Set to main branch at '$DIR_DESTINATION'"

                        if git fetch && git pull && git config pull.rebase false; then

                            echo "Main branch updated at '$DIR_DESTINATION'"

                            UPDATED="$DIR_DESTINATION;$UPDATED"

                        else

                            echo "ERROR: Failed to update main branch at '$DIR_DESTINATION'"
                            exit 1
                        fi

                    else

                        echo "ERROR: Failed to set the main branch at '$DIR_DESTINATION'"
                        exit 1
                    fi

                fi

                if cd "$LOCATION"; then

                    echo "Entered starting point directory: '$LOCATION'"

                else

                    echo "ERROR: Could not enter starting point directory '$LOCATION'"
                    exit 1
                fi

            else

                echo "Git submodule repository '$REPO' will be initialized into '$DIR_DESTINATION'"

                if git submodule add "$REPO" "$DIR_DESTINATION"; then

                    if cd "$DIR_DESTINATION" && git config pull.rebase false && cd "$LOCATION"; then

                        echo "Git merging strategy set for: '$DIR_DESTINATION'"

                    else

                        echo "ERROR: Could not set Git merging strategy for '$DIR_DESTINATION'"
                        exit 1
                    fi

                    echo "Git submodule repository '$REPO' has been initialized into '$DIR_DESTINATION'"

                    DIR_UPSTREAMS="$DIR_DESTINATION/Upstreams"

                    if test -e "$DIR_UPSTREAMS"; then

                        echo "Bringing up Upstreams from '$DIR_UPSTREAMS'"

                        DIR_UPSTREAMABLE="$LOCATION/Upstreamable"
                        SCRIPT_INSTALL_UPSTREAMS="$DIR_UPSTREAMABLE/install_upstreams.sh"

                        if test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

                            sh "$SCRIPT_INSTALL_UPSTREAMS" "$DIR_UPSTREAMS"

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

        else

            echo "ERROR: Submodule path does not exist '$APSOLUTE_SUBMOPDULE_PATH'"
            exit 1
        fi
    fi
}

DO_FILE() {

    if [ -z "$1" ]; then

        echo "ERROR: File path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$1"
    
    echo "Git modules file: $FILE"

    REPO=""
    SUBMODULE=""
    SUBMODULE_PATH=""
    
    SUBMODULE_OPENING="[submodule"
    SUBMODULE_URL_MARK="url = "
    SUBMODULE_PATH_MARK="path = "
    
    CONTENT=$(cat "$FILE")

    IFS=$'\n'

    for ITEM in $CONTENT; do

        if [ ! "$ITEM" = ""  ]; then

            if check_prefixes "$ITEM" "$SUBMODULE_OPENING"; then

                SUBMODULE=$(echo "$ITEM" | grep -o -P '(?<=").*(?=")')
            fi

            if check_contains "$ITEM" "$SUBMODULE_URL_MARK"; then

                REPO=$(echo "$ITEM" | grep -o -P '(?<=url = ).*(?=)')
            fi

            if check_contains "$ITEM" "$SUBMODULE_PATH_MARK"; then

                SUBMODULE_PATH=$(echo "$ITEM" | grep -o -P '(?<=path = ).*(?=)')
            fi

            if [ ! "$SUBMODULE" = "" ] && [ ! "$REPO" = "" ] && [ ! "$SUBMODULE_PATH" = "" ]; then

                DO_SUBMODULE "$SUBMODULE" "$REPO" "$SUBMODULE_PATH" "$FILE"

                REPO=""
                SUBMODULE=""
                SUBMODULE_PATH=""
            fi
        fi
    done;
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    if check_prefixes "$FILE" "$DIR_SUBMODULES_FULL"; then

        echo "SKIPPING: '$FILE'"

    else
    
        DO_FILE "$FILE"
    fi
done;
