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

    APSOLUTE_SUBMOPDULE_PATH="$DIR_PARENT/$SUBMODULE_PATH"

    if check_prefixes "$SUBMODULE_PATH" "$DIR_SUBMODULES_FULL"; then

        echo "SKIPPING: Git submodule path '$SUBMODULE_PATH'"

    else

        if test -e "$APSOLUTE_SUBMOPDULE_PATH"; then

            if cd "$APSOLUTE_SUBMOPDULE_PATH"; then

                echo "Entered directory: '$APSOLUTE_SUBMOPDULE_PATH'"

                MAIN_BRANCH=""
                LAST_MAIN_COMMIT=""

                if git log -n 1 main | grep "commit "; then

                    MAIN_BRANCH="main"

                else

                    MAIN_BRANCH="master"
                fi

                CURRENT_COMMIT=$(git rev-parse HEAD)
                LAST_MAIN_COMMIT=$(git log -n 1 "$MAIN_BRANCH" | grep "commit ")
                LAST_MAIN_COMMIT=$(echo "$LAST_MAIN_COMMIT" | grep -o -P '(?<=commit ).*(?=)')

                if [ "$LAST_MAIN_COMMIT" = "" ]; then

                    echo "ERROR: Last main commit was not obtained for the Git submodule at '$APSOLUTE_SUBMOPDULE_PATH'"
                    exit 1
                fi

                if [ "$CURRENT_COMMIT" = "" ]; then

                    echo "ERROR: Current commit was not obtained for the Git submodule at '$APSOLUTE_SUBMOPDULE_PATH'"
                    exit 1
                fi

                echo "Last on main commit: $LAST_MAIN_COMMIT, Current commit: $CURRENT_COMMIT"
                
                if [ "$LAST_MAIN_COMMIT" = "$CURRENT_COMMIT" ]; then

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

                            echo "Entered starting point directory (3): '$LOCATION'"

                        else

                            echo "ERROR: Could not enter starting point directory (3) '$LOCATION'"
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

                echo "ERROR: Could not enter directory '$APSOLUTE_SUBMOPDULE_PATH'"
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

# TODO: Recipe
# 
# 10047  mkdir GitTest
# 10048  cd GitTest/
# 10049  git init
# 10050  mkdir _Submodules
# 10051  cd _Submodules/
# 10052  git submodule add git@github.com:red-elf/Upstreamable.git ./Upstreamable
# 10053  ls
# 10054  cd ..
# 10055  git submodule add git@github.com:Helix-Track/Core.git ./Core
# 10056  cd Core/
# 10057  ls
# 10058  git submodule init
# 10059  git submodule update
# 10060  cd Upstreamable/
# 10061  git submodule deinit
# 10062  cd ..
# 10063  git submodule deinit --all
# 10064  ls
# 10065  cd Upstreamable/
# 10066  ls
# 10067  cd ..
# 10068  cd ..
# 10069  ln -s _Submodules/Upstreamable/ Core/Upstreamable/
# 10070  cd Core/Upstreamable/
# 10071  ls
# 10072  cd ..
# 10073  cd ..
# 10074  cd _Submodules/
# 10075  ls
# 10076  cd Upstreamable/
# 10077  ls
# 10078  cd ..
# 10079  cd ..
# 10080  ln -s _Submodules/Upstreamable/ Core
# 10081  rm -f ./Core/Upstreamable/ && ln -s ./_Submodules/Upstreamable/ ./Core/Upstreamable/
# 10082  rm -rf ./Core/Upstreamable/ && ln -s ./_Submodules/Upstreamable/ ./Core/Upstreamable/
# 10083  rm -rf ./Core/Upstreamable/ && ln -s ./_Submodules/Upstreamable/ ./Core/Upstreamable/
# 10084  rm -rf ./Core/Upstreamable/ && ln -sf ./_Submodules/Upstreamable/ ./Core/Upstreamable/
# 10085  rm -rf ./Core/Upstreamable/ && ln -sf ./_Submodules/Upstreamable/ ./Core
# 10086  cd Core/
# 10087  ls
# 10088  cd Upstreamable
# 10089  ls
# 10090  cd ..
# 10091  ls
# 10092  ls -lF
# 10093  cd ..
# 10094  rm -rf ./Core/Upstreamable/ && ln -sf ./_Submodules/Upstreamable ./Core
# 10095  cd Core/
# 10096  ls -LF
# 10097  ls -LFa
# 10098  ls -lF
# 10099  cd Upstreamable
# 10100  ls
# 10101  cd ..
# 10102  cd ..
# 10103  rm -rf ~/Documents/Temp/GitTest/Core/Upstreamable/ && ln -sf ~/Documents/Temp/GitTest/_Submodules/Upstreamable ~/Documents/Temp/GitTest/Core
# 10104  cd Core/
# 10105  ls -lF
# 10106  cd Upstreamable
# 10107  ls
# 10108  cd ..
# 10109  cd ..