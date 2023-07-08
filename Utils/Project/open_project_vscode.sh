#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: Project parameter not ptovided"
  exit 1
fi

PROJECT="$1"
PROGAM="code"
HERE="$(dirname -- "$0")"
SCRIPT_GET_PROGRAM="$HERE/../Sys/Programs/get_program.sh"

if sh "$SCRIPT_GET_PROGRAM" "$PROGAM"; then

  "$PROGAM" "$PROJECT"

else
  
  echo "ERROR: VSCode is not availble to open the project $PROJECT"
  exit 1
fi
