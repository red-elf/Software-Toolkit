#!/bin/bash

HERE="$(pwd)"
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
. "$FILE_RC" >/dev/null 2>&1

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

  FILE_PATH="$(dirname -- "$FILE")"

  if cd "$FILE_PATH"; then

    echo "Entered: '$FILE_PATH'"

  else

    echo "ERROR: Could not eneter '$FILE_PATH'"
    exit 1
  fi

  MAIN_BRANCH=""

  if git log -n 1 main | grep "commit " >/dev/null 2>&1; then

      MAIN_BRANCH="main"

  else

      if git log -n 1 master | grep "commit " >/dev/null 2>&1; then

        MAIN_BRANCH="master"

      fi
  fi

  if [ "$MAIN_BRANCH" = "main" ] || [ "$MAIN_BRANCH" = "master" ]; then

    if git status | grep "HEAD detached at "; then

      echo "SKIPPING (head detached): '$FILE'"

    else

      DO_FILE "$FILE" "$SCRIPT_DO_SUBMODULE"

    fi

  else

    echo "SKIPPING (not on main branch): '$FILE'" 
  fi
  
  echo "Entered directory: '$FILE_PATH' :: MARK"
  # TODO: Process the current directory as the submodule

  # FIXME: Running push_all from exported path; Kill identity logs.
  #
  # Agent pid 98688
  # Identity added: ...
  # Identity added: ...
  # ERROR: The SUBMODULES_HOME is not defined

  if cd "$HERE"; then

    echo "Got back to: '$HERE'"

  else

    echo "ERROR: Could not go back to '$HERE'"
    exit 1
  fi

done;