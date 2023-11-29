#!/bin/bash

RUN_IN_TERMINAL() {

  if [ -z "$1" ]; then

    echo "ERROR: Command to run parameter is mandatory"
    exit 1
  fi

  COMMAND_TO_RUN="$1"

  if which mate-terminal >/dev/null 2>&1; then

    mate-terminal --geometry=250x70 -e "$COMMAND_TO_RUN"
    
  else

    gnome-terminal --geometry=250x70 -- /bin/bash -ic "source ~/.bashrc && $COMMAND_TO_RUN; read"
  fi
}