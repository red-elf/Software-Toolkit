#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: Please provide the target"
  exit 1
fi

TARGET="$1"

if test -e "$TARGET"; then

  echo "Initializing the Software Toolkit into the directory: '$TARGET'"

else

  echo "ERROR: The '$TARGET' directory does not exist"
  exit 1
fi