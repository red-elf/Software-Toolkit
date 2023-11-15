#!/bin/bash

LINK_FILE_TO_DESTINATION() {

  if [ -z "$1" ]; then

    echo "ERROR: Link what path parameter not provided"
    exit 1
  fi

  if [ -z "$2" ]; then

    echo "ERROR: Link to path parameter not provided"
    exit 1
  fi

  LINK_WHAT="$1"
  LINK_TO="$2"

  if [ "$LINK_WHAT" == "$LINK_TO" ]; then

    echo "SKIPPING: $LINK_WHAT"

  else

    if ! test -e "$LINK_WHAT"; then

      echo "ERROR: Source does not exist '$LINK_WHAT'"
      exit 1
    fi

    if test -e "$LINK_TO"; then

      if ! rm -f "$LINK_TO"; then

        echo "ERROR: Link to was ot cleaned up '$LINK_TO'"
        exit 1
      fi
    fi

    if ln -s "$LINK_WHAT" "$LINK_TO"; then

      echo "Linked: $LINK_WHAT -> $LINK_TO"
    fi
  fi
}
