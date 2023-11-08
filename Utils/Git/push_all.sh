#!/bin/bash

# TODO: 
#
# - Extend to support the commiting out of the box, for example: push_all "My commit message"
# - Push all to go directoy by directiry backwards until it finds the Upstreams direcotry, then use it and push to upstreams

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_INSTALL_UPSTREAMS="$SUBMODULES_HOME/Upstreamable/install_upstreams.sh"

if ! test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_UPSTREAMS'"
  exit 1
fi

DIR_UPSTREAMS="Upstreams"

if [ -n "$1" ]; then

  DIR_UPSTREAMS="$1"
fi

if test -e "$DIR_UPSTREAMS"; then

  if ! sh "$SCRIPT_INSTALL_UPSTREAMS" "$DIR_UPSTREAMS"; then

    echo "ERROR: Installing upstreams failed from '$DIR_UPSTREAMS'"
    exit 1
  fi

  UNSET_UPSTREAM_VARIABLES() {

    unset UPSTREAMABLE_REPOSITORY

    if [ -n "$UPSTREAMABLE_REPOSITORY" ]; then

      echo "ERROR: The UPSTREAMABLE_REPOSITORY environment variable is still set"
      exit 1
    fi
  }

  PROCESS_UPSTREAM() {

    if [ -z "$1" ]; then

      echo "ERROR: No upstream repository provided"
      exit 1
    fi

    if [ -z "$2" ]; then

      echo "ERROR: No upstream name provided"
      exit 1
    fi

    UPSTREAM="$1"
    NAME="$2"

    if echo "Upstream '$NAME': $UPSTREAM" && git push "$NAME"; then

      git config pull.rebase false && git fetch && git pull && echo "'$NAME': OK"
    fi
  }

  cd "$DIR_UPSTREAMS" && echo "Processing upstreams from: $DIR_UPSTREAMS"

  for i in *.sh; do

    UNSET_UPSTREAM_VARIABLES

    if test -e "$i"; then

      UPSTREAM_FILE="$(pwd)"/"$i"
      # shellcheck disable=SC1090
      echo "Processing the upstream file: $UPSTREAM_FILE" && . "$UPSTREAM_FILE"

      FILE_NAME=$(basename -- "$i")
      FILE_NAME="${FILE_NAME%.*}"
      FILE_NAME=$(echo "$FILE_NAME" | tr '[:upper:]' '[:lower:]')

      PROCESS_UPSTREAM "$UPSTREAMABLE_REPOSITORY" "$FILE_NAME"

    else

      echo "ERROR: '$i' not found at: '$(pwd)' (2)"
      exit 1
    fi
  done

  if git push --tags; then

    echo "All tags have been pushed with success"

  else

    echo "ERROR: Tags have failed to be pushed pushed to upstream"
    exit 1
  fi

else

  echo "WARNING: Upstreams sources path does notexist '$DIR_UPSTREAMS'"
fi