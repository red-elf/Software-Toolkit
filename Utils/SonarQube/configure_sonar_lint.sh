#!/bin/bash

HERE="$(pwd)"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.json.sh"
RECIPE_IDE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.IDE.json.sh"

SCRIPT_GET_CODE_PATHS="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode/get_paths.sh"
SCRIPT_EXTEND_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/JSON/merge_jsons.sh"
SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"

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
  SETTINGS_JSON_IDE="$HERE/.vscode"
  SETTINGS_SONAR_CONFIGS_DIR="$SETTING_DIR/sonarConfigs"

  echo "Checking: '$SETTINGS_JSON'"

  if test -e "$SETTINGS_JSON"; then

    echo "Settings JSON: '$SETTINGS_JSON'"

  else

    if echo "{}" > "$SETTINGS_JSON"; then

      echo "Settings JSON created: '$SETTINGS_JSON'"

    else

      echo "ERROR: Could not create '$SETTINGS_JSON'"
      exit 1
    fi
  fi

  echo "Checking: '$SETTINGS_JSON_IDE'"

  if test -e "$SETTINGS_JSON_IDE"; then

    echo "IDE settings JSON: '$SETTINGS_JSON_IDE'"

  else

    if echo "{}" > "$SETTINGS_JSON_IDE"; then

      echo "IDE settings JSON created: '$SETTINGS_JSON_IDE'"

    else

      echo "ERROR: Could not create '$SETTINGS_JSON_IDE'"
      exit 1
    fi
  fi

  if [ -n "$1" ]; then

    RECIPE_SETTINGS_JSON="$1"
  fi

  if [ -n "$2" ]; then

    RECIPE_IDE_SETTINGS_JSON="$2"
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
PROJECT=\"$SONARQUBE_PROJECT\"
SERVER=\"$SONARQUBE_SERVER\"
"
    SONAR_CONFIG_FILE="$SETTINGS_SONAR_CONFIGS_DIR/$SONARQUBE_PROJECT.sonarConfig.sh"

    if echo "$SONAR_CONFIG_CONTENT" > "$SONAR_CONFIG_FILE"; then

      echo "The Sonar Confing file has been written: '$SONAR_CONFIG_FILE'"

    else

      echo "ERROR: Could not write the Sonar Confing file '$SONAR_CONFIG_FILE'"
      exit 1
    fi

    CONTENT=$(sh "$RECIPE_SETTINGS_JSON")
    SONAR_CONFIG_JSON="$SETTINGS_SONAR_CONFIGS_DIR/$SONARQUBE_PROJECT.sonarConfig.json"

    if [ "$CONTENT" = "" ]; then

      echo "ERROR: No settings JSON content obtained from '$RECIPE_SETTINGS_JSON'"

    else

      if echo "$CONTENT" > "$SONAR_CONFIG_JSON"; then

        echo "The Sonar Confing JSON has been written: '$SONAR_CONFIG_JSON'"

        if sh "$SCRIPT_EXTEND_JSON" "$SETTINGS_JSON" "$SONAR_CONFIG_JSON" "$SETTINGS_JSON"; then

          echo "SonarLint connections have been configured"

        else

          echo "ERROR: SonarLint connections have not been configured"
          exit 1
        fi

        # TODO: Finsih this
        #
        CONTENT=$(sh "$RECIPE_IDE_SETTINGS_JSON")
        SONAR_CONFIG_JSON_IDE="$SETTINGS_SONAR_CONFIGS_DIR/$SONARQUBE_PROJECT.sonarConfig.IDE.json"

        if echo "$CONTENT" > "$SONAR_CONFIG_JSON_IDE"; then

          if sh "$SCRIPT_EXTEND_JSON" "$SETTINGS_JSON_IDE" "$SONAR_CONFIG_JSON_IDE" "$SETTINGS_JSON_IDE"; then

            echo "IDE has been configured for the SonarLint"

          else

            echo "ERROR: IDE not has been configured for the SonarLint"
            exit 1
          fi

        else

          echo "ERROR: Could not write the Sonar Confing IDE JSON '$SONAR_CONFIG_JSON_IDE'"
          exit 1
        fi

      else

        echo "ERROR: Could not write the Sonar Confing JSON '$SONAR_CONFIG_JSON'"
        exit 1
      fi
    fi
    
  else

    echo "WARNING: No SonarLint will be configured"
    echo "SONARQUBE_GROUP='$SONARQUBE_GROUP'"
    echo "SONARQUBE_SERVER='$SONARQUBE_SERVER'"
    echo "SONARQUBE_PROJECT='$SONARQUBE_PROJECT'"
  fi
fi
