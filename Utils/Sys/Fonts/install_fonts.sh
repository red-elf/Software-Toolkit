#!/bin/bash

HERE=$(pwd)
DIR_HOME=$(eval echo ~"$USER")
DIR_SOURCE="$HERE/Assets/Fonts"
DIR_DESTINATION="$DIR_HOME/.local/share/fonts"

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

if [ -n "$1" ]; then

    DIR_SOURCE="$1"
fi

if [ -n "$2" ]; then

    DIR_DESTINATION="$2"
fi

if ! test -e "$DIR_SOURCE"; then

    echo "ERROR: The fonts source directory not found '$DIR_SOURCE'"
    exit 1
fi

if ! test -e "$DIR_DESTINATION"; then

    echo "ERROR: The fonts destination directory not found '$DIR_DESTINATION'"
    exit 1
fi

echo "Installing fonts into: '$DIR_DESTINATION'"

INSTALL_FONT() {

    read -r FONT

    if ! [ "$FONT" = "" ]; then

        FILE_NAME=$(basename -- "$FONT")

        if ! test -e "$FONT"; then

            echo "ERROR: Font does not exist '$FONT'"
            exit 1
        fi

        if test -e "$DIR_DESTINATION/$FILE_NAME"; then

            echo "Font is already installed: '$FILE_NAME'"

        else

            echo "Installing font: '$FILE_NAME'"

            if CHECK_PREFIXES "$DIR_HOME" "$DIR_DESTINATION"; then

                if cp "$FONT" "$DIR_DESTINATION"; then

                    echo "Font has been installed: '$FILE_NAME'"
                fi

            else

                echo "Please rpovide your sudo password for the '$FONT' to be installed to your system"

                if sudo cp "$FONT" "$DIR_DESTINATION"; then

                    echo "Font has been installed: '$FILE_NAME'"
                fi
            fi
        fi
    fi
}

find "$DIR_SOURCE" -name "*.otf" | INSTALL_FONT
find "$DIR_SOURCE" -name "*.ttf" | INSTALL_FONT