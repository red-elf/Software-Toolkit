#!/bin/bash

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
. "$FILE_RC"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_STRINGS="$SUBMODULES_HOME/Software-Toolkit/Utils/strings.sh"

if test -e "$SCRIPT_STRINGS"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_STRINGS"

else

  echo "ERROR: Script not found '$SCRIPT_STRINGS'"
  exit 1
fi

SCRIPT_FLAGS="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/gather_submodules_flags.sh"

if test -e "$SCRIPT_FLAGS"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_FLAGS"

else

    echo "ERROR: Flags script not found '$SCRIPT_FLAGS'"
    exit 1
fi

if [ -n "$1" ]; then

    if check_contains "$1" "FLAGS="; then
    
        FLAGS="$1"
    fi
fi

if [ -n "$2" ]; then

    if check_contains "$2" "FLAGS="; then
    
        FLAGS="$2"
    fi
fi

if [ -n "$FLAGS" ]; then

    if ! check_contains "$FLAGS" "$CLOSE]"; then

        echo "ERROR: Invalid Flags parameter '$FLAGS', must close with '$CLOSE]'"
    fi

    echo "Flags: $FLAGS"
fi

UPDATED=""
LOCATION="$(pwd)"
DIR_SUBMODULES="_Submodules"
DIR_SUBMODULES_FULL="$LOCATION/$DIR_SUBMODULES"

if [ -n "$1" ]; then

    if ! check_contains "$1" "FLAGS="; then
    
        LOCATION="$1"
    fi
fi

echo "We are going to gather Git submodules information from: $LOCATION"

if ! test -e "$DIR_SUBMODULES_FULL"; then

    if ! mkdir -p "$DIR_SUBMODULES_FULL"; then

        echo "ERROR: Could not create directory '$DIR_SUBMODULES_FULL'"
        exit 1
    fi
fi

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

    APSOLUTE_SUBMOPDULE_PATH="$DIR_PARENT/$SUBMODULE_PATH"

    if check_prefixes "$SUBMODULE_PATH" "$DIR_SUBMODULES_FULL"; then

        echo "SKIPPING: Git submodule path '$SUBMODULE_PATH'"

    else

        if test -e "$APSOLUTE_SUBMOPDULE_PATH"; then

            if cd "$APSOLUTE_SUBMOPDULE_PATH"; then

                echo "Entered directory (1): '$APSOLUTE_SUBMOPDULE_PATH'"

                MAIN_BRANCH=""

                if git log -n 1 main | grep "commit "; then

                    MAIN_BRANCH="main"

                else

                    MAIN_BRANCH="master"
                fi
                
                if git symbolic-ref HEAD | grep "refs/heads/$MAIN_BRANCH"; then

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

                    # TODO: Extract function into separate shell script

                    DO_UPDATE() {

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

                        if check_contains "$UPDATED" "$DIR_REPOSITORY;"; then

                            echo "SKIPPING: Already recently set to the main branch and updated at: '$DIR_REPOSITORY'"

                        else

                            echo "We are about to checkout branch: '$BRANCH' at '$DIR_REPOSITORY'"

                            if git checkout "$BRANCH" && git fetch; then

                                echo "We have checked out branch: '$BRANCH' at '$DIR_REPOSITORY'"

                                CURRENT_COMMIT=$(git rev-parse HEAD)
                                LAST_MAIN_COMMIT=$(git log -n 1 "origin/$BRANCH" | grep "commit ")
                                LAST_MAIN_COMMIT=$(echo "$LAST_MAIN_COMMIT" | grep -o -P '(?<=commit ).*(?=)')

                                if [ "$CURRENT_COMMIT" = "$LAST_MAIN_COMMIT" ]; then

                                    echo "Branch '$BRANCH' is already at the latest commit: $CURRENT_COMMIT"

                                else

                                    # TODO: If provided update only provided repo, othervise skip

                                    if git pull && git config pull.rebase false; then

                                        echo "Branch '$BRANCH' updated at: '$DIR_REPOSITORY'"

                                        if ! check_contains "$FLAGS" "$FLAG_UPDATE_ALWAYS"; then

                                            if check_contains "$FLAGS" "$FLAG_UPDATE_ONLY"; then

                                                UPDATE_ONLY=$(echo "$FLAGS" | grep -o -P "(?<=$FLAG_UPDATE_ONLY=).*(?=)")
                                                UPDATE_ONLY=$(echo "$UPDATE_ONLY" | cut -f1 "-d$CLOSE" )

                                                if [ "$UPDATE_ONLY" = "" ]; then

                                                    echo "ERROR: Got empty path for the '$FLAG_UPDATE_ONLY' flag"

                                                else

                                                    if test -e "$UPDATE_ONLY"; then

                                                        if [ "$UPDATE_ONLY" -ef "$DIR_REPOSITORY" ]; then

                                                            echo "Update only, will be updating: $SUBMODULE"

                                                        else

                                                            echo "Update only, will be skipping: $SUBMODULE"

                                                            UPDATED="$DIR_REPOSITORY;$UPDATED"
                                                        fi

                                                    else

                                                        echo "ERROR: Path '$UPDATE_ONLY' does not exist for the '$FLAG_UPDATE_ONLY' flag"
                                                        exit 1
                                                    fi
                                                fi
                                            
                                            else
                                            
                                                UPDATED="$DIR_REPOSITORY;$UPDATED"
                                            fi
                                        fi

                                    else

                                        echo "ERROR: Failed to update '$BRANCH' branch at '$DIR_REPOSITORY'"
                                        exit 1
                                    fi

                                fi

                            else

                                echo "ERROR: Failed to set the '$BRANCH' branch at '$DIR_REPOSITORY'"
                                exit 1
                            fi
                        fi

                        if cd "$LOCATION"; then

                            echo "Entered starting point directory (3): '$LOCATION'"

                        else

                            echo "ERROR: Could not enter starting point directory (3) '$LOCATION'"
                            exit 1
                        fi
                    }

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

                    if cd "$LOCATION"; then

                        echo "Entered starting point directory (2): '$LOCATION'"

                    else

                        echo "ERROR: Could not enter starting point directory (2) '$LOCATION'"
                        exit 1
                    fi

                    DO_UPDATE "$APSOLUTE_SUBMOPDULE_PATH"
                    DO_UPDATE "$DIR_DESTINATION"

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

# TODO: Extend push_all script so it:
#
# - After the update commit head changes and push them all to upstream with generic commit message and some additional info if needed.

if check_contains "$FLAGS" "$FLAG_HELLO"; then

    echo "Test hello flag is on. Well then, HELLO! :)"
fi