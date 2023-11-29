#!/bin/bash

LOCATION=$(pwd)

if [ -n "$1" ]; then

    LOCATION="$1"
fi

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

if [ -z "$SONARQUBE_SERVER" ]; then

    echo "ERROR: 'SONAR_QUBE_SERVER' variable not defined (exported)"
    exit 1
fi

if [ -z "$SONARQUBE_TOKEN" ]; then

    echo "ERROR: 'SONARQUBE_TOKEN' variable not defined (exported)"
    exit 1
fi

if [ -z "$SONARQUBE_PROJECT" ]; then

    echo "ERROR: 'SONARQUBE_PROJECT' variable not defined (exported)"
    exit 1
fi

PROGRAM="sonar-scanner"

if ! sh "$SCRIPT_GET_PROGRAM" "$PROGRAM"; then

    # shellcheck disable=SC1090
    if ! . "$SCRIPT_GET_SONAR_SCANNER"; then

        echo "ERROR: Could not get the '$PROGRAM'"
        exit 1
    fi
fi

if sh "$SCRIPT_GET_PROGRAM" "$PROGRAM"; then

    if ! "$PROGRAM" \
        -Dsonar.projectKey="$SONARQUBE_PROJECT" \
        -Dsonar.sources="$LOCATION" \
        -Dsonar.host.url="$SONARQUBE_SERVER" \
        -Dsonar.token="$SONARQUBE_TOKEN" \
        -Dsonar.scm.disabled=True; then

        echo "ERROR: Failed to run '$PROGRAM'"
        exit 1
    fi

else
  
  echo "ERROR: $PROGRAM is not availble to open the project $PROJECT"
  exit 1
fi