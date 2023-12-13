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

if bash "$SCRIPT_GET_PROGRAM" code >/dev/null 2>&1; then

    GET_VSCODE_PATHS >/dev/null 2>&1

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
        CONFIG_ADDED=false
        CONTENT_CONNECTIONS="\"sonarlint.connectedMode.connections.sonarqube\": ["

        for FILE_CONFIG in "$SETTINGS_SONAR_CONFIGS_DIR"/*.sh; do

            # shellcheck disable=SC1090
            . "$FILE_CONFIG"

            if [ -n "$SERVER" ] && [ -n "$PROJECT" ] && [ -n "$GROUP" ]; then

              CONFIG_JSON="{
  \"serverUrl\": \"$SERVER\",
  \"connectionId\": \"$GROUP\"
}"

              if [ "$CONFIG_ADDED" = true ]; then

                CONFIG_JSON=", $CONFIG_JSON"
              fi
            
              CONTENT_CONNECTIONS="$CONTENT_CONNECTIONS$CONFIG_JSON"

              CONFIG_ADDED=true
            fi

        done

        CONTENT_CONNECTIONS="$CONTENT_CONNECTIONS]"
        CONTENT_JSON="$CONTENT_JSON$CONTENT_CONNECTIONS}"

        echo "$CONTENT_JSON"
    fi
fi