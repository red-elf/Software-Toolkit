#!/bin/bash

REPLACE() {
  
  if [ -n "$1" ]; then

    FROM="$1"

  else

    echo "ERROR: The 'From' parameter is mandatory"
    exit 1
  fi

  if [ -n "$2" ]; then

    WHAT="$2"

  else

    echo "ERROR: The 'What' parameter is mandatory"
    exit 1
  fi

  if [ -n "$3" ]; then

    WITH="$3"

  else

    echo "ERROR: The 'With' parameter is mandatory"
    exit 1
  fi

  echo "$WHAT -> $WITH"
  
  echo "ERROR: Not implemented"
  exit 1
}