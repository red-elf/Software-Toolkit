#!/bin/bash

HERE="$(pwd)"
DIR_TOOLKIT="Toolkit"
DIR_DEPENDABLE="Dependable"
DIR_VERSIONABLE="Versionable"
DIR_INSTALLABLE="Installable"
DIR_UPSTREAMABLE="Upstreamable"

function UPDATE_MODULE {

  if [ -z "$1" ]; then

    echo "ERROR: The Software Toolkit module directory not provided"
    exit 1
  fi

  DIR="$1"

  if test -e "$DIR"; then

    if cd "$DIR" && git checkout main && git fetch && git pull; then

      if test -e "Upstreams"; then

        echo "We are going to update from the upstreams"
        if ! git fetch upstream && git pull upstream main; then

          echo "ERROR: Failed to fetch and pull the upstreams"
          exit 1
        fi
      fi

      cd "$HERE" &&
        echo "The Software Toolkit module updated: '$DIR'"
    else

      echo "ERROR: Could not update the Software Toolkit: '$DIR'"
      exit 1
    fi
  else

    echo "WARNING: Software Toolkit module '$DIR' not found at '$(pwd)'"
  fi
}

UPDATE_MODULE "$DIR_TOOLKIT"
UPDATE_MODULE "$DIR_VERSIONABLE"
UPDATE_MODULE "$DIR_INSTALLABLE"
UPDATE_MODULE "$DIR_DEPENDABLE"
UPDATE_MODULE "$DIR_UPSTREAMABLE"
