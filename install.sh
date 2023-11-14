#!/bin/bash

HERE="$(dirname -- "$0")"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not defined"
  exit 1
fi

# shellcheck disable=SC2012
FILES_COUNT=$(ls "$SUBMODULES_HOME" -1 | wc -l)

if [ ! "$FILES_COUNT" == 0 ]; then

  echo "ERROR: Directory is not empty '$SUBMODULES_HOME'"
  exit 1
fi

TARGET="$SUBMODULES_HOME"

if test -e "$TARGET"; then

  echo "Installing the Software Toolkit into: '$TARGET' (1)"

else

  if mkdir -p "$TARGET"; then

    if test -e "$TARGET"; then

      echo "Installing the Software Toolkit into: '$TARGET' (2)"

    else
    
      echo "ERROR: The '$TARGET' directory does not exist"
      exit 1
    fi

  else

    echo "ERROR: The '$TARGET' directory failed to create"
    exit 1
  fi
fi

SCRIPT_INSTALL="$HERE/Recipes/Installable/install.sh"

if ! test -e "$SCRIPT_INSTALL"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL'"
  exit 1
fi

echo "Installing Software-Toolkit"

sh "$SCRIPT_INSTALL"

