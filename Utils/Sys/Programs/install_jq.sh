#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_CHECK_ALT_LINUX="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Recipes/altlinux.sh"

if ! test -e "$SCRIPT_CHECK_ALT_LINUX"; then

  echo "ERROR: Script not found '$SCRIPT_CHECK_ALT_LINUX'"
  exit 1
fi

if bash "$SCRIPT_CHECK_ALT_LINUX"; then

  if sudo apt-get install jq; then

    exit 0
  fi
fi

echo "ERROR: JQ was not installed"
exit 1
