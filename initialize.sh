#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: Please provide the target"
  exit 1
fi

TARGET="$1"

echo "Initializing the Software Toolkit target: $TARGET"