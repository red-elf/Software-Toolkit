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

DIR_EXTENSIONS="$CODE_DATA_DIR/extensions"
DIR_USER_DATA="$CODE_DATA_DIR/user-data"

if [ -z "$DIR_EXTENSIONS" ]; then

  echo "ERROR: the 'DIR_EXTENSIONS' variable is not set"
  exit 1
fi

if [ -z "$DIR_USER_DATA" ]; then

  echo "ERROR: the 'DIR_USER_DATA' variable is not set"
  exit 1
fi

if [ -z "$VSCODE_DATA_PUBLISH_DESTINATION" ]; then

  if [ -z "$1" ]; then

    echo "ERROR: VSCode data publish destination parameter is mandatory"
    exit 1
  fi

  VSCODE_DATA_PUBLISH_DESTINATION="$1"
fi

echo "We are going to publish the new VSCode data version into '$VSCODE_DATA_PUBLISH_DESTINATION'"

if ! test -e "$VSCODE_DATA_PUBLISH_DESTINATION"; then

  if ! mkdir -p "$VSCODE_DATA_PUBLISH_DESTINATION"; then

    echo "ERROR: Failed to create destination directory '$VSCODE_DATA_PUBLISH_DESTINATION'"
    exit 1
  fi
fi

# TODO: Implement

echo "ERROR: Publish new data version is not implemented yet"
exit 1