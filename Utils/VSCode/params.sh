#!/bin/bash

DIR_HOME="$(readlink --canonicalize ~)"

# shellcheck disable=SC2034
DIR_INSTALLATION_HOME="$DIR_HOME/VSCode"

# shellcheck disable=SC2034
DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"