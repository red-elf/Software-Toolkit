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

FILE_DATA_VERSION_NAME="data_version.txt"
FILE_DATA_VERSION="$VSCODE_DATA_PUBLISH_DESTINATION/$FILE_DATA_VERSION_NAME"

if ! test -e "$VSCODE_DATA_PUBLISH_DESTINATION"; then

  VERSION="1.0.0"

else

  VERSION=$(cat "$FILE_DATA_VERSION")
  NEXT_VERSION=$(echo "${VERSION}" | awk -F. -v OFS=. '{$NF += 1 ; print}')

  echo "Current version is: $VERSION"
  echo "Next version is going to be: $NEXT_VERSION"

  VERSION="$NEXT_VERSION"
fi

SESSION=$(($(date +%s%N)/1000000))

if cp "$FILE_DATA_VERSION" "$VSCODE_DATA_PUBLISH_DESTINATION/$SESSION.$FILE_DATA_VERSION_NAME.bak"; then

  if echo "$VERSION" > "$FILE_DATA_VERSION.tmp"; then

    echo "Creating the extensions and user data"

    # TODO: Move tmp file into the permanent one
  fi

else

  echo "ERROR: Could not create a backup '$FILE_DATA_VERSION' file"
  exit 1
fi
