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

  # WHAT="{{SERVICE.SONAR_QUBE.NAME}}"
  # WITH="@@@@"

  PROCESSED="${FROM//${WHAT}/${WITH}}"

  if [ -n "$4" ]; then

    INTO="$4"

    if ! test -e "$INTO"; then

      echo "ERROR: Destination does not exist '$INTO'"
      exit 1
    fi

    echo "$WHAT -> $WITH"
    echo "$PROCESSED" > "$INTO"

  else

    echo "$PROCESSED"
  fi
}