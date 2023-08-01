#!/bin/bash

DIR_HOME="$(readlink --canonicalize ~)"
DIR_INSTALLATION_HOME="$DIR_HOME/VSCode"

DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"