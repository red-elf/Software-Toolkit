#!/bin/bash

HERE=$(pwd)

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_INSTALL_UPSTREAMS="$SUBMODULES_HOME/Upstreamable/install_upstreams.sh"

if ! test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_UPSTREAMS'"
  exit 1
fi

UPSTREAMS_LC="upstreams"
UPSTREAMS_UC="Upstreams"
# Detect the canonical recipes directory in the current working tree.
# Prefers lowercase 'upstreams/' per Helix Constitution §11.4.29; falls
# back to legacy 'Upstreams/'. If both exist, lowercase wins.
if test -e "$UPSTREAMS_LC"; then
  UPSTREAMS="$UPSTREAMS_LC"
else
  UPSTREAMS="$UPSTREAMS_UC"
fi
DIR_UPSTREAMS="$UPSTREAMS"

if [ -n "$1" ]; then

  DIR_UPSTREAMS="$1"

  echo "Upstreams directory parametrized: '$DIR_UPSTREAMS'"

else

  if ! test -e "$DIR_UPSTREAMS"; then

    ORIGIN=$(git config --get remote.origin.url)
    DIR_UPSTREAMS="$HERE"

    echo "Looking for the Upstreams directory from: '$DIR_UPSTREAMS'" && \
      echo "From origin: '$ORIGIN'"

    while ! test -e "$DIR_UPSTREAMS/$UPSTREAMS_LC" && ! test -e "$DIR_UPSTREAMS/$UPSTREAMS_UC"
    do

      DIR_UPSTREAMS="$DIR_UPSTREAMS/.." && \
        echo "Going back to: '$DIR_UPSTREAMS'"

      CURRENT_ORIGIN=$(git config --get remote.origin.url)

      if [ "$ORIGIN" == "" ] || ! [ "$ORIGIN" == "$CURRENT_ORIGIN" ]; then

        echo "ERROR: Went out of origin '$ORIGIN' to '$CURRENT_ORIGIN'"
        exit 1
      fi

    done

    # Resolve which case wins at this level — lowercase preferred per §11.4.29.
    if test -e "$DIR_UPSTREAMS/$UPSTREAMS_LC"; then
      UPSTREAMS="$UPSTREAMS_LC"
    elif test -e "$DIR_UPSTREAMS/$UPSTREAMS_UC"; then
      UPSTREAMS="$UPSTREAMS_UC"
    fi

    if test -e "$DIR_UPSTREAMS/$UPSTREAMS"; then

      CURRENT_ORIGIN=$(git config --get remote.origin.url)

      if [ ! "$ORIGIN" == "" ] && [ "$ORIGIN" == "$CURRENT_ORIGIN" ]; then

        DIR_UPSTREAMS="$DIR_UPSTREAMS/$UPSTREAMS"

        echo "Upstreams directory found at: '$DIR_UPSTREAMS'" && \
          echo "At origin: '$CURRENT_ORIGIN'"

      fi
    fi
  fi
fi

if test -e "$DIR_UPSTREAMS"; then

  if ! bash "$SCRIPT_INSTALL_UPSTREAMS" "$DIR_UPSTREAMS"; then

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

  echo "Pushing tags"

  if git push --tags >/dev/null 2>&1; then

    echo "All tags have been pushed with success"

  else

    echo "ERROR: Tags have failed to be pushed pushed to upstream"
    exit 1
  fi

else

  echo "WARNING: Upstreams sources path does not exist '$DIR_UPSTREAMS'"
fi