#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_GET_CODE_PATHS="$SUBMODULES_HOME/Software-Toolkit/Utils/VSCode/get_paths.sh"
SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"

if ! test -e "$SCRIPT_GET_CODE_PATHS"; then

  echo "ERROR: Script not found '$SCRIPT_GET_CODE_PATHS'"
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
    SETTINGS_SONAR_CONFIGS_DIR="$SETTING_DIR/sonarConfigs"

    if test -e "$SETTINGS_SONAR_CONFIGS_DIR"; then

        CONTENT_JSON="{"

# TODO:
#
#     \"sonarlint.connectedMode.connections.sonarqube\": [
#         {
#             \"serverUrl\": \"$SONARQUBE_SERVER\",
#             \"connectionId\": \"$SONARQUBE_PROJECT\"
#         }
#     ],
#     \"sonarlint.connectedMode.project\": {
#         \"connectionId\": \"$SONARQUBE_PROJECT\",
#         \"projectKey\": \"$SONARQUBE_PROJECT\"
#     }
# }"

        

        CONTENT_JSON="$CONTENT_JSON}"
    fi
fi