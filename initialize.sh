#!/bin/bash

HERE="$(pwd)"
ABOUT="ABOUT.txt"
SCRIPT_VERSION="version.sh"

DIR_VERSION="Version"
DIR_RECIPES="Recipes"
DIR_DEPENDENCIES="Dependencies"

DEPENDABLE="git@github.com:red-elf/Dependable.git"
INSTALLABLE="git@github.com:red-elf/Installable.git"
VERSIONABLE="git@github.com:red-elf/Versionable.git"

if [ -z "$1" ]; then

  echo "ERROR: Please provide the target"
  exit 1
fi

if [ -z "$2" ]; then

  echo "ERROR: Please provide the project name"
  exit 1
fi

TARGET="$1"
PROJECT_NAME="$2"

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
  echo "$PROJECT_NAME" > "$ABOUT" && \
  mkdir "$DIR_VERSION" && cd "$DIR_VERSION" && \
  echo "#!/bin/bash
export VERSIONABLE_SNAPSHOT=true
export VERSIONABLE_NAME=\"$PROJECT_NAME\"
export VERSIONABLE_VERSION_PRIMARY=\"1\"
export VERSIONABLE_VERSION_SECONDARY=\"0\"
export VERSIONABLE_VERSION_PATCH=\"0\"" > "$SCRIPT_VERSION" && \
  chmod +x "$SCRIPT_VERSION" && \
  cd .. && \
  mkdir "$DIR_RECIPES" && cp "$HERE/Templates/Recipes/"*.sh "./$DIR_RECIPES" && \
  cd .. && \
  mkdir "$DIR_DEPENDENCIES"
  echo "The Software Toolkit has been initialized into: '$TARGET'"

