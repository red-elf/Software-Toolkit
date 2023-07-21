#!/bin/bash

HERE="$(dirname -- "$0")"
SCRIPT_CHECK_ALT_LINUX="$HERE/../Recipes/altlinux.sh"

if ! test -e "$SCRIPT_CHECK_ALT_LINUX"; then

  echo "ERROR: Script not found '$SCRIPT_CHECK_ALT_LINUX'"
  exit 1
fi

if sh "$SCRIPT_CHECK_ALT_LINUX"; then

  if sudo apt-get install docker-compose && docker-compose -version; then

    exit 0
  fi
fi

echo "ERROR: Docker was not installed"
exit 1
