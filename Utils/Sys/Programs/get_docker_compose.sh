#!/bin/bash

HERE="$(dirname -- "$0")"
SCRIPT_GET_PROGRAM="$HERE/get_program.sh"
SCRIPT_INSTALL_DOCKER_COMPOSE="$HERE/install_docker_compose.sh"

if ! sh "$SCRIPT_GET_PROGRAM" docker-compose; then

  if [ -z "$1" ]; then

    INSTALL=false

  else

    INSTALL=$3
  fi

  if $INSTALL; then

    echo "We are about to install Docker Compose" && sh "$SCRIPT_INSTALL_DOCKER_COMPOSE"
  fi
fi
