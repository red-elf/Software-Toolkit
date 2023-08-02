#!/bin/bash

HERE="$(dirname -- "$0")"
PARAMS="$HERE/params.sh"
INSTALL_SCRIPT="Installable/install.sh"

if ! test -e "$PARAMS"; then

    echo "ERROR: No parameters file available '$PARAMS'"
    exit 1
fi

# shellcheck disable=SC1090
. "$PARAMS"

if [ -n "$1" ]; then

    PARAMS_OVERRIDES="$1"

    if ! test -e "$PARAMS_OVERRIDES"; then

        echo "ERROR: No parameters overrides file available '$PARAMS_OVERRIDES'"
        exit 1
    fi

    # shellcheck disable=SC1090
    . "$PARAMS_OVERRIDES"

    echo "Parameters overrides file loaded from: '$PARAMS_OVERRIDES'"
fi

if ! test -e "$INSTALL_SCRIPT"; then

    echo "ERROR: Install script not found '$INSTALL_SCRIPT'"
    exit 1
fi

# TODO: Pass the values to the installation script by exporting mandatory variables

sh "$INSTALL_SCRIPT"