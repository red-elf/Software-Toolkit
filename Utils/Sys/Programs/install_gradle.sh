#!/bin/bash

CURRENT="$(pwd)"
HERE="$(dirname -- "$0")"
GRADLE_VERSION="8.2.1"
DIR_DOWNLOADS="$(eval echo ~$USER)/Downloads"
SCRIPT_CHECK_ALT_LINUX="$HERE/../Recipes/altlinux.sh"
URL_GRADLE_INSTALL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip"

if [ -n "$1" ]; then

  GRADLE_VERSION="$1"
fi

if ! test -e "$SCRIPT_CHECK_ALT_LINUX"; then

  echo "ERROR: Script not found '$SCRIPT_CHECK_ALT_LINUX'"
  exit 1
fi

if sh "$SCRIPT_CHECK_ALT_LINUX"; then

  if ! test -e "$DIR_DOWNLOADS"; then

    echo "ERROR: No Downloads directory available to download the Gradle installation '$DIR_DOWNLOADS'"
    exit 1
  fi

  if cd "$DIR_DOWNLOADS" && wget "$URL_GRADLE_INSTALL" && cd "$CURRENT"; then

    exit 0
  fi
fi

echo "ERROR: Gradle was not installed"
exit 1
