#!/bin/bash

REPLACE() {
  
  if [ -n "$1" ]; then

    WHAT="$1"

  else

    echo "ERROR: The 'What' parameter is mandatiry"
    exit 1
  fi

  if [ -n "$2" ]; then

    WITH="$3"

  else

    echo "ERROR: The 'With' parameter is mandatiry"
    exit 1
  fi

  echo "ERROR: Not implemented"
}