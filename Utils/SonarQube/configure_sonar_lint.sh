#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.json.sh"
SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"
SCRIPT_EXTEND_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/JSON/merge_jsons.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

  echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
  exit 1
fi

if ! test -e "$SCRIPT_EXTEND_JSON"; then

  echo "ERROR: Script not found '$SCRIPT_EXTEND_JSON'"
  exit 1
fi

if sh "$SCRIPT_GET_PROGRAM" code >/dev/null 2>&1; then

  CODE_PATH=$(which code)

  if test -e "$CODE_PATH"; then

    echo "VSCode path: '$CODE_PATH'"

  else

    echo "ERROR: VSCode Path not found '$CODE_PATH'"
    exit 1
  fi

  CODE_DIR=$(dirname "$CODE_PATH")
  SETTINGS_JSON="$CODE_DIR/data/user-data/User/settings.json"

  echo "Checking: '$SETTINGS_JSON'"

  if test -e "$SETTINGS_JSON"; then

    echo "Settings JSON: '$SETTINGS_JSON'"

  else


    if echo "{}" >> "$SETTINGS_JSON"; then

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

    echo "Settings JSON recipe: '$RECIPE_SETTINGS_JSON'"

  else

    echo "ERROR: Settings JSON recipe not found '$RECIPE_SETTINGS_JSON'"
    exit 1
  fi

  if [ -n "$SONARQUBE_SERVER" ] && [ -n "$SONARQUBE_PROJECT" ]; then
    
    if sh "$SCRIPT_EXTEND_JSON" "$SETTINGS_JSON" "$RECIPE_SETTINGS_JSON" "$SETTINGS_JSON"; then

      echo "SonarLint has been configured"

    else

      echo "ERROR: SonarLint has not been configured"
      exit 1
    fi

  else

    echo "WARNING: No SonarLint will be configured"
    echo "SONARQUBE_SERVER='$SONARQUBE_SERVER'"
    echo "SONARQUBE_PROJECT='$SONARQUBE_PROJECT'"
  fi
fi
