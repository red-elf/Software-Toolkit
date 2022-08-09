#!/bin/bash

DEPENDABLE="git@github.com:red-elf/Dependable.git"
INSTALLABLE="git@github.com:red-elf/Installable.git"
VERSIONABLE="git@github.com:red-elf/Versionable.git"

if [ -z "$1" ]; then

  echo "ERROR: Please provide the target"
  exit 1
fi

TARGET="$1"

if test -e "$TARGET"; then

  echo "Initializing the Software Toolkit into: '$TARGET'"

else

  echo "ERROR: The '$TARGET' directory does not exist"
  exit 1
fi

if cd "$TARGET" && ! git status; then

  echo "Initializing the Git repository at: '$(pwd)'" && \
    git init .
fi

git status &&
  git submodule add "$INSTALLABLE" ./Installable && \
  git submodule add "$DEPENDABLE" ./Dependable && \
  git submodule add "$VERSIONABLE" ./Versionable && \
  echo "The Software Toolkit has been initialized into: '$TARGET'"

