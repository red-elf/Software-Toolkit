#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

GET_VSCODE_PATHS() {

    CODE_PATH=$(which code)

    if test -e "$CODE_PATH"; then

        echo "VSCode path: '$CODE_PATH'"

    else

        echo "ERROR: VSCode Path not found '$CODE_PATH'"
        exit 1
    fi

    CODE_DIR=$(dirname "$CODE_PATH")
    
    export CODE_DIR
    export CODE_DATA_DIR="$CODE_DIR/data/"
}