#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_INSTALL_UPSTREAMS="$SUBMODULES_HOME/Upstreamable/install_upstreams.sh"

if ! test -e "$SCRIPT_INSTALL_UPSTREAMS"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_UPSTREAMS'"
  exit 1
fi

# TODO:
#
# - Upstreams installation to check if already installed, remove all upstream definition duplicates if found
#
# Tech notes:
#
# file git
#   Root:       .git: directory
#   Submodule:  .git: ASCII text
#
# cat .git
#   gitdir: ../../.git/modules/_Submodules/Software-Toolkit
#
# cd ../../.git/modules/_Submodules/Software-Toolkit
#
# more config
#   [core]
#   repositoryformatversion = 0
#   filemode = true
#   bare = false
#   logallrefupdates = true
#   worktree = ../../../../_Submodules/Software-Toolkit
# [remote "origin"]
#   url = git@github.com:red-elf/Software-Toolkit.git
#   fetch = +refs/heads/*:refs/remotes/origin/*
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
#   pushurl = git@gitflic.ru:red-elf/software-toolkit.git
#   pushurl = git@github.com:red-elf/Software-Toolkit.git
# [branch "main"]
#   remote = origin
#   merge = refs/heads/main
# [remote "gitflic"]
#   url = git@gitflic.ru:red-elf/software-toolkit.git
#   fetch = +refs/heads/*:refs/remotes/gitflic/*
# [remote "upstream"]
#   url = git@gitflic.ru:red-elf/software-toolkit.git
#   fetch = +refs/heads/*:refs/remotes/upstream/*
# [remote "github"]
#   url = git@github.com:red-elf/Software-Toolkit.git
#   fetch = +refs/heads/*:refs/remotes/github/*
# [pull]
#   rebase = false
# 
# ^^^ Remove all duplicates, for new installations check of the existing strings existence!   

DIR_UPSTREAMS="Upstreams"

if [ -n "$1" ]; then

  DIR_UPSTREAMS="$1"
fi

if test -e "$DIR_UPSTREAMS"; then

  echo "Upstreams sources path: '$DIR_UPSTREAMS'"

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

      git config pull.rebase false && git fetch && git pull
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