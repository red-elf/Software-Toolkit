#!/bin/bash

if [ -z "$GENERAL_SERVER" ]; then

    echo "ERROR: 'GENERAL_SERVER' variable is not set"
    exit 1
fi

# shellcheck disable=SC2034
DOWNLOAD_URL_EXTENSIONS="http://$GENERAL_SERVER:8081/extensions.1.0.0.tar.gz"