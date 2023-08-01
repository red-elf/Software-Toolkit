#!/bin/bash

INSTALL_SCRIPT="Installable/install.sh"

if ! test -e "$INSTALL_SCRIPT"; then

    echo "ERROR: Install script not found '$INSTALL_SCRIPT'"
    exit 1
fi

sh "$INSTALL_SCRIPT"