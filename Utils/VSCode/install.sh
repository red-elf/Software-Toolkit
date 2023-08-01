#!/bin/bash

HERE="$(pwd)"
PARAMS="$HERE/params.sh"
INSTALL_SCRIPT="Installable/install.sh"

if ! test -e "$PARAMS"

    echo "ERROR: No parameters file available '$PARAMS'"
    exit 1
fi

, "$PARAMS"

if [ -n "$1" ]; then

    PARAMS_OVERRIDES="$1"

    if ! test -e "$PARAMS_OVERRIDES"; then

        echo "ERROR: No parameters overrides file available '$PARAMS_OVERRIDES'"
        exit 1
    fi

    . "$PARAMS_OVERRIDES"

    echo "Parameters overrides file loaded from: '$PARAMS_OVERRIDES'"
fi

if ! test -e "$INSTALL_SCRIPT"; then

    echo "ERROR: Install script not found '$INSTALL_SCRIPT'"
    exit 1
fi

# TODO: Pass the values to the installation script by exporting mandatory variables

sh "$INSTALL_SCRIPT"