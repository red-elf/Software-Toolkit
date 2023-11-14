#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not defined"
  exit 1
fi

if [ -z "$REPO_ICONIC" ]; then

  REPO_ICONIC="git@github.com:red-elf/Iconic.git"
fi

if [ -z "$REPO_PROJECT" ]; then

  REPO_PROJECT="git@github.com:red-elf/Project.git"
fi

if [ -z "$REPO_TESTABLE" ]; then

  REPO_TESTABLE="git@github.com:red-elf/Testable.git"
fi

if [ -z "$REPO_DEPENDABLE" ]; then

  REPO_DEPENDABLE="git@github.com:red-elf/Dependable.git"
fi

if [ -z "$REPO_INSTALLABLE" ]; then

  REPO_INSTALLABLE="git@github.com:red-elf/Installable.git"
fi

if [ -z "$REPO_VERSIONABLE" ]; then

  REPO_VERSIONABLE="git@github.com:red-elf/Versionable.git"
fi

if [ -z "$REPO_TOOLKIT" ]; then

  REPO_TOOLKIT="git@github.com:red-elf/Software-Toolkit.git"
fi

if [ -z "$REPO_UPSTREAMABLE" ]; then

  REPO_UPSTREAMABLE="git@github.com:red-elf/Upstreamable.git"
fi

TARGET="$SUBMODULES_HOME"

if cd "$TARGET" && ! git status; then

  git init . &&
    git submodule add "$REPO_TOOLKIT" ./Software-Toolkit && \
    git submodule add "$REPO_INSTALLABLE" ./Installable && \
    git submodule add "$REPO_DEPENDABLE" ./Dependable && \
    git submodule add "$REPO_VERSIONABLE" ./Versionable && \
    git submodule add "$REPO_UPSTREAMABLE" ./Upstreamable && \
    git submodule add "$REPO_TESTABLE" ./Testable && \
    git submodule add "$REPO_ICONIC" ./Iconic && \
    git submodule add "$REPO_PROJECT" ./Project && \
    git submodule init && git submodule update && \
    echo "Software-Toolkit has been installed:" && \
    cd "$SUBMODULES_HOME" && ls -lF
    
else

  echo "ERROR: Installation directory is invalid '$TARGET'"
  exit 1  
fi

