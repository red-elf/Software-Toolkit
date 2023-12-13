#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

    echo "ERROR: The SUBMODULES_HOME is not defined"
    exit 1
fi

SCRIPT_PUSH_ALL="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/push_all.sh"

if ! test -e "$SCRIPT_PUSH_ALL"; then

    echo "ERROR: Push all script not found '$SCRIPT_PUSH_ALL'"
    exit 1
fi

SESSION=$(($(date +%s%N)/1000000))
MESSAGE="Auto-commit $SESSION"

if [ -n "$1" ]; then

    MESSAGE="$1"
fi

if git add .; then

    if git commit -m "$MESSAGE"; then

        bash "$SCRIPT_PUSH_ALL"
    fi
fi