#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: Command parameter not provided"
  exit 1
fi

CMD="$1"

if which "$CMD" >/dev/null 2>&1; then

  echo "$CMD is avaiable"

else

  echo "ERROR: $CMD is not available"
  exit 1
fi
