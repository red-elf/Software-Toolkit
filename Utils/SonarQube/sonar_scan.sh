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

if sh "$SCRIPT_GET_PROGRAM" "$PROGRAM"; then

  if ! "$PROGRAM" \
          -Dsonar.projectKey="$SONARQUBE_PROJECT" \
          -Dsonar.sources="$LOCATION" \
          -Dsonar.host.url="$SONARQUBE_SERVER" \
          -Dsonar.token="$SONARQUBE_TOKEN"; then

    # TODO:
    #
    # Missing blame information for 2 files. This may lead to some features not working correctly. 
    # Please check the analysis logs and refer to the documentation:
    # https://docs.sonarsource.com/sonarqube/10.1/analyzing-source-code/scm-integration/

    echo "ERROR: Failed to run '$PROGRAM'"
    exit 1
fi

else
  
  echo "ERROR: VSCode is not availble to open the project $PROJECT"
  exit 1
fi