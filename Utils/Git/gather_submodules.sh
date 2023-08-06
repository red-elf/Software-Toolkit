#!/bin/bash

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

    SUBMODULE="$1"
    REPO="$2"

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

    FILE_NAME="$NAME.submodule"
    FILE_NAME_FULL="$DIR_SUBMODULES_FULL/$FILE_NAME"
    
    echo "Processing Git submodule Name='$NAME', Submodule='$SUBMODULE', Repo='$REPO'"

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
    fi
}

DO_FILE() {

    if [ -z "$1" ]; then

        echo "ERROR: File path is mandatory parameter for the function"
        exit 1
    fi

    FILE="$1"
    
    echo "Processing Git modules file: $FILE"

    REPO=""
    SUBMODULE=""    
    SUBMODULE_OPENING="[submodule"
    SUBMODULE_URL_MARK="url = "
    
    CONTENT=$(cat "$FILE")

    IFS=$'\n'

    for ITEM in $CONTENT; do

        if check_prefixes "$ITEM" "$SUBMODULE_OPENING"; then

            SUBMODULE=$(echo "$ITEM" | grep -o -P '(?<=").*(?=")')

        else

            if check_contains "$ITEM" "$SUBMODULE_URL_MARK"; then

                REPO=$(echo "$ITEM" | grep -o -P '(?<=url = ).*(?=)')

                DO_SUBMODULE "$SUBMODULE" "$REPO"

                SUBMODULE=""
                REPO=""
            fi
        fi
    done;
}

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE"
done;
