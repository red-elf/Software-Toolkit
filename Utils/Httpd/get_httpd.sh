#!/bin/bash

if [ -n "$1" ]; then
  
  NAME="$1"

else
  
  echo "ERROR: Name parameter is not provided"
  exit 1
fi

if [ -n "$2" ]; then
  
  DIR_WEB_ROOT="$2"

else
  
  echo "ERROR: Web root parameter is not provided"
  exit 1
fi

if [ -n "$3" ]; then
  
  HTTPD_PORT="$3"

else
  
  echo "ERROR: HTTPD port parameter is not provided"
  exit 1
fi

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_GET_DOCKER="$SUBMODULES_HOME/Utils/Sys/Programs/get_docker.sh"

if sh "$SCRIPT_GET_DOCKER" true; then

    if docker run -dit --name "$NAME" -p "$HTTPD_PORT":80 -v "$PWD":"$DIR_WEB_ROOT" httpd:2.4; then

        echo "Apache HTTPD has been started"

    else

        echo "ERROR: Apache HTTPD was not started"
        exit 1
    fi

else

    echo "ERROR: No mandatory installations (docker) available on the system"
    exit 1
fi