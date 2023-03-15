#!/bin/bash

WHERE="$pwd"

if [ -n $1 ]; then

  WHERE="$1"
fi

echo "Updating the Software Toolkit recursively from: $WHERE"

for dir in "$WHERE"
do
    dir=${dir%*/}
    echo "${dir##*/}"
done