#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

UTIL_PROGRAMS="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Programs"

if ! test -e "$UTIL_PROGRAMS"; then

  echo "ERROR: Path not found '$UTIL_PROGRAMS'"
  exit 1;
fi

SCRIPT_GET_PROGRAM="$UTIL_PROGRAMS/get_program.sh"
SCRIPT_INSTALL_DOCKER="$UTIL_PROGRAMS/install_docker.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

  echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
  exit 1;
fi

if ! test -e "$SCRIPT_INSTALL_DOCKER"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_DOCKER'"
  exit 1;
fi

if ! bash "$SCRIPT_GET_PROGRAM" docker; then

  if [ -z "$1" ]; then

    INSTALL=false

  else

    INSTALL=$3
  fi

  if $INSTALL; then

    echo "We are about to install Docker" && bash "$SCRIPT_INSTALL_DOCKER"
  fi
fi
