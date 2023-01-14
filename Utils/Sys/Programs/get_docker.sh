#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_PROGRAM="$HERE/get_program.sh"
SCRIPT_INSTALL_DOCKER="$HERE/install_docker.sh"

if ! sh "$SCRIPT_GET_PROGRAM" docker; then

  if [ -z "$1" ]; then

    INSTALL=false

  else

    INSTALL=$3
  fi

  if $INSTALL; then

    echo "We are about to install Docker" && sh "$SCRIPT_INSTALL_DOCKER"
  fi
fi
