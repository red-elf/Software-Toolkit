#!/bin/bash

CURRENT="$(pwd)"
HERE="$(dirname -- "$0")"
GRADLE_VERSION="8.2.1"
DIR_INSTALLATION="/opt/gradle"
GRADLE_ZIP="gradle-$GRADLE_VERSION.zip"
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

  if test -e "$DIR_INSTALLATION"; then

    if ! sudo rm -rf "$DIR_INSTALLATION"; then

      echo "ERROR: Could not remove '$DIR_INSTALLATION'"
      exit 1
    fi
  fi

  if ! sudo mkdir -p "$DIR_INSTALLATION"; then

    echo "ERROR: Could not create '$DIR_INSTALLATION'"
    exit 1
  fi

  if ! test -e "$DIR_DOWNLOADS/$GRADLE_ZIP"; then

    if ! wget -O "$DIR_DOWNLOADS/$GRADLE_ZIP" "$URL_GRADLE_INSTALL"; then

      echo "ERROR: The Gradle installation failed to download"
      exit 1
    fi
  fi

  if cd "$DIR_DOWNLOADS" && test -e "$GRADLE_ZIP"  && \
    sudo unzip -d "$DIR_INSTALLATION" "$GRADLE_ZIP" && ls "$DIR_INSTALLATION" && \
    cd "$CURRENT"; then

    exit 0
  fi
fi

echo "ERROR: Gradle was not installed"
exit 1
