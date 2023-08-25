#!/bin/bash

DIR_HOME=$(eval echo ~"$USER")
FILE_ZSH_RC="$DIR_HOME/.zshrc"
FILE_BASH_RC="$DIR_HOME/.bashrc"

export SESSION=$(($(date +%s%N)/1000000))

FILE_RC=""
    
if test -e "$FILE_ZSH_RC"; then

  FILE_RC="$FILE_ZSH_RC"

else

    if test -e "$FILE_BASH_RC"; then

      FILE_RC="$FILE_BASH_RC"

    else

      echo "ERROR: No '$FILE_ZSH_RC' or '$FILE_BASH_RC' found on the system"
      exit 1
    fi
fi

# shellcheck disable=SC1090
. "$FILE_RC"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_STRINGS="$SUBMODULES_HOME/Software-Toolkit/Utils/strings.sh"
SCRIPT_DO_FILE="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/do_file.sh"
SCRIPT_DO_SUBMODULE="$SUBMODULES_HOME/Software-Toolkit/Utils/Git/do_submodule_push.sh"

if test -e "$SCRIPT_STRINGS"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_STRINGS"

else

  echo "ERROR: Script not found '$SCRIPT_STRINGS'"
  exit 1
fi

if test -e "$SCRIPT_DO_FILE"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_DO_FILE"

else

  echo "ERROR: Script not found '$SCRIPT_DO_FILE'"
  exit 1
fi

LOCATION="$(pwd)"

if [ -n "$1" ]; then

    LOCATION=$(realpath "$1")
fi

echo "We are going to push all submodule head positions recursively from: $LOCATION"

# shellcheck disable=SC2044
for FILE in $(find "$LOCATION" -type f -name '.gitmodules');
do
    
    DO_FILE "$FILE" "$SCRIPT_DO_SUBMODULE"
done;

# FIXME:
# 
# Entered starting point directory: '/home/milosvasic/Projects/HelixTrack/Core'
# Git submodule: Name='Upstreamable', Submodule='/home/milosvasic/Projects/HelixTrack/Core/_Submodules/Upstreamable', Repo='git@github.com:red-elf/Upstreamable.git', Path='/home/milosvasic/Projects/HelixTrack/Core//home/milosvasic/Projects/HelixTrack/Core/_Submodules/Upstreamable'
# ERROR: Submodule full path does not exist '/home/milosvasic/Projects/HelixTrack/Core//home/milosvasic/Projects/HelixTrack/Core/_Submodules/Upstreamable'