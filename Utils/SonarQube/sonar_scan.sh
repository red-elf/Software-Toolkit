#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_GET_PROGRAM="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs/get_program.sh"
SCRIPT_GET_SONAR_SCANNER="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/get_sonar_scanner.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

    echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
    exit 1
fi

if ! test -e "$SCRIPT_GET_SONAR_SCANNER"; then

    echo "ERROR: Script not found '$SCRIPT_GET_SONAR_SCANNER'"
    exit 1
fi

PROGRAM="sonar-scanner"

if sh "$SCRIPT_GET_PROGRAM" "$PROGRAM"; then

  if ! "$PROGRAM" \
          -Dsonar.projectKey=Core \
          -Dsonar.sources=. \
          -Dsonar.host.url=http://general-server.local:9102 \
          -Dsonar.token=TOKEN_TO_SET; then

    echo "ERROR: Failed to run '$PROGRAM'"
    exit 1
fi

else
  
  echo "ERROR: VSCode is not availble to open the project $PROJECT"
  exit 1
fi