#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: the version parameter is not provided"
  exit 1
fi

VERSION="$1"

NEXT_VERSION=$(echo "${VERSION}" | awk -F. -v OFS=. '{$NF += 1 ; print}')

echo "$NEXT_VERSION"