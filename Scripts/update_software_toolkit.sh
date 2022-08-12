#!/bin/bash

HERE="$(pwd)"
DIR_DEPENDABLE="Dependable"
DIR_VERSIONABLE="Versionable"
DIR_INSTALLABLE="Installable"

if test -e "$DIR_DEPENDABLE"; then

  if ! cd "$DIR_DEPENDABLE" && git submodule update --remote && cd "$HERE"; then

    echo "ERROR: Could not update the Software Toolkit: '$DIR_DEPENDABLE'"
    exit 1
  fi
else

  echo "WARNING: Software Toolkit module '$DIR_DEPENDABLE' not found at '$(pwd)'"
fi

if test -e "$DIR_VERSIONABLE"; then

  if ! cd "$DIR_VERSIONABLE" && git submodule update --remote && cd "$HERE"; then

    echo "ERROR: Could not update the Software Toolkit: '$DIR_VERSIONABLE'"
    exit 1
  fi
else

  echo "WARNING: Software Toolkit module '$DIR_VERSIONABLE' not found at '$(pwd)'"
fi

if test -e "$DIR_INSTALLABLE"; then

  if ! cd "$DIR_INSTALLABLE" && git submodule update --remote && cd "$HERE"; then

    echo "ERROR: Could not update the Software Toolkit: '$DIR_INSTALLABLE'"
    exit 1
  fi
else

  echo "WARNING: Software Toolkit module '$DIR_INSTALLABLE' not found at '$(pwd)'"
fi