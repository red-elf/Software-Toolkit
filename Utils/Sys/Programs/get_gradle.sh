#!/bin/bash

HERE="$(dirname -- "$0")"
SCRIPT_GET_PROGRAM="$HERE/get_program.sh"
SCRIPT_INSTALL_GRADLE="$HERE/install_gradle.sh"

if ! sh "$SCRIPT_GET_PROGRAM" gradle; then

  if [ -z "$1" ]; then

    INSTALL=false

  else

    INSTALL=$3
  fi

  if $INSTALL; then

    echo "We are about to install Gradle" && sh "$SCRIPT_INSTALL_GRADLE"
  fi
fi
