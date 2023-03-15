#!/bin/bash

WHERE="$pwd"

if [ -n $1 ]; then

  WHERE="$1"
fi

echo "Updating the Software Toolkit recursively from: $WHERE"

cd "$WHERE"
PATHS=$(find . -maxdepth 100 -mindepth 1 -type d)

for PATH in $PATHS
do
    echo ">>> $PATH"
done
