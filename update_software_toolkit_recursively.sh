#!/bin/bash

WHERE="$(pwd)"
SCRIPT_UPDATE="update_software_toolkit.sh"

if [ -n "$1" ]; then

  cd "$1" && WHERE="$1"
fi

echo "Updating the Software Toolkit recursively from: $WHERE"

PATHS=$(find . -maxdepth 100 -mindepth 1 -type d)

for PATH in $PATHS
do
    
    if test -e "$PATH/Toolkit/$SCRIPT_UPDATE"; then

      if [ $PATH = *"_Dependencies"* ]; then
        
        echo "SKIPPING: $PATH"

      else 

        echo "Updatining by: $PATH/$SCRIPT_UPDATE" &&
          cd "$PATH" && ./Toolkit/"$SCRIPT_UPDATE" && cd "$WHERE" && echo "Update OK"
      fi
    fi
done
