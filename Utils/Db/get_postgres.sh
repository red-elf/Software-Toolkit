#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"

DB="database.db"

if [ -n "$1" ]; then

  DB="$1"
fi

if sh "$SCRIPT_GET_DOCKER" true; then

  echo "ERROR: Not implemented"
  exit 1

else

  echo "ERROR: No Docker installation available"
  exit 1
fi
