#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.json.sh"
SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"
SCRIPT_EXTEND_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/JSON/merge_jsons.sh"
SCRIPT_GET_CODE_PATHS="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode/get_paths.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

  echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
  exit 1
fi

if ! test -e "$SCRIPT_EXTEND_JSON"; then

  echo "ERROR: Script not found '$SCRIPT_EXTEND_JSON'"
  exit 1
fi

if ! test -e "$SCRIPT_GET_CODE_PATHS"; then

  echo "ERROR: Script not found '$SCRIPT_GET_CODE_PATHS'"
  exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_GET_CODE_PATHS"

if sh "$SCRIPT_GET_PROGRAM" code >/dev/null 2>&1; then

  GET_VSCODE_PATHS

  if [ -z "$CODE_DIR" ]; then

    echo "ERROR: the 'CODE_DIR' variable is not set"
    exit 1
  fi

  if [ -z "$CODE_DATA_DIR" ]; then

    echo "ERROR: the 'CODE_DIR' variable is not set"
    exit 1
  fi

  SETTING_DIR="$CODE_DATA_DIR/user-data/User"
  SETTINGS_JSON="$SETTING_DIR/settings.json"
  SETTINGS_SONAR_CONFIGS_DIR="$SETTING_DIR/sonarConfigs"

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

  if [ -n "$SONARQUBE_SERVER" ] && [ -n "$SONARQUBE_PROJECT" ] && [ -n "$SONARQUBE_GROUP" ]; then

    if ! test -e "$SETTINGS_SONAR_CONFIGS_DIR"; then

      if ! mkdir -p "$SETTINGS_SONAR_CONFIGS_DIR"; then

        echo "ERROR: Could not create directory '$SETTINGS_SONAR_CONFIGS_DIR'"
        exit 1
      fi
    fi

    SONAR_CONFIG_CONTENT="#!/bin/bash

GROUP=\"$SONARQUBE_GROUP\"
SERVER=\"$SONARQUBE_SERVER\"
PROJECT=\"$SONARQUBE_PROJECT\"
"
    SONAR_CONFIG_FILE="$SETTINGS_SONAR_CONFIGS_DIR/$SONARQUBE_PROJECT.sonarConfig.sh"

    if ! echo "$SONAR_CONFIG_CONTENT" > "$SONAR_CONFIG_FILE"; then

      echo "ERROR: Could not write the Sonar Confing file '$SONAR_CONFIG_FILE'"
      exit 1
    fi
    
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
