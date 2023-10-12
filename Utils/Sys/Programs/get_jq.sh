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
SCRIPT_INSTALL_JQ="$UTIL_PROGRAMS/install_jq.sh"

if ! test -e "$SCRIPT_GET_PROGRAM"; then

  echo "ERROR: Script not found '$SCRIPT_GET_PROGRAM'"
  exit 1;
fi

if ! test -e "$SCRIPT_INSTALL_JQ"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_JQ'"
  exit 1;
fi

if ! sh "$SCRIPT_GET_PROGRAM" jq; then

  if [ -z "$1" ]; then

    INSTALL=false

  else

    INSTALL=$3
  fi

  if $INSTALL; then

    echo "We are about to install JQ" && sh "$SCRIPT_INSTALL_JQ"
  fi
fi
