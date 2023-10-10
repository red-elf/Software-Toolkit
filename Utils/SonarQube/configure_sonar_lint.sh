#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.json.sh"
SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"
SCRIPT_EXTEND_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode/extend_settings_json.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

  echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
  exit 1
fi

if ! test -e "$SCRIPT_EXTEND_JSON"; then

  echo "ERROR: Script not found '$SCRIPT_EXTEND_JSON'"
  exit 1
fi

if sh "$SCRIPT_GET_PROGRAM" code; then

  CODE_PATH=$(which code)

  if ! test -e "$CODE_PATH"; then

    echo "ERROR: VSCode Path not found '$CODE_PATH'"
    exit 1
  fi

  SETTINGS_JSON="$CODE_PATH/data/user-data/User/settings.json"

  if test -e "$SETTINGS_JSON"; then

    echo "Settings JSON: '$SETTINGS_JSON'"

  else

    if touch "$SETTINGS_JSON"; then

      echo "Settings JSON created: '$SETTINGS_JSON'"

    else

      echo "ERROR: Could not create '$SETTINGS_JSON'"
      exit 1
    fi
  fi

  if [ -n "$1" ]; then

    RECIPE_SETTINGS_JSON="$1"
  fi

  if test -e "$RECIPE_SETTINGS_JSON"; then

    echo "Settings.json recipe: '$RECIPE_SETTINGS_JSON'"

  else

    echo "ERROR: Recipe not found '$RECIPE_SETTINGS_JSON'"
    exit 1
  fi

  if sh "$SCRIPT_EXTEND_JSON" "$RECIPE_SETTINGS_JSON"; then

    echo "Settings JSON has been extended with success"

  else

    echo "ERROR: Settings JSON failed to extend"
    exit 1
  fi
fi
