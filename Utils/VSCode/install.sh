#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

INSTALLER="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode"

if ! test -e "$INSTALLER"; then

    echo "ERROR: VSCode installer path not available '$INSTALLER'"
    exit 1
fi

PARAMS="$INSTALLER/parameters.sh"
INSTALL_SCRIPT="$SUBMODULES_HOME/Installable/install.sh"

if ! test -e "$PARAMS"; then

    echo "ERROR: No parameters file available '$PARAMS' (1)"
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

export DATA_VERSION
export DOWNLOAD_URL
export DIR_INSTALLATION_HOME
export DOWNLOAD_URL_EXTENSIONS

if [ -n "$DOWNLOAD_URL_USER_DATA" ]; then

    export DOWNLOAD_URL_USER_DATA
fi

sh "$INSTALL_SCRIPT" "$INSTALLER"