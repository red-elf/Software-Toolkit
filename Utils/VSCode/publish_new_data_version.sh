#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_GET_CODE_PATHS="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode/get_paths.sh"

if ! test -e "$SCRIPT_GET_CODE_PATHS"; then

  echo "ERROR: Script not found '$SCRIPT_GET_CODE_PATHS'"
  exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_GET_CODE_PATHS"

GET_VSCODE_PATHS

if [ -z "$CODE_DIR" ]; then

  echo "ERROR: the 'CODE_DIR' variable is not set"
  exit 1
fi

if [ -z "$CODE_DATA_DIR" ]; then

  echo "ERROR: the 'CODE_DIR' variable is not set"
  exit 1
fi

echo "VSCode hoem directory: '$CODE_DIR'"

# TODO: Implement

echo "ERROR: Publish new data version is not implemented yet"
exit 1