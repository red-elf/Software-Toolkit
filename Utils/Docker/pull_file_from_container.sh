#!/bin/bash

if [ -n "$1" ]; then
  
  if [ -n "$2" ]; then

    if [ -n "$3" ]; then
  
      docker cp --follow-link "$2":/"$1" "$3"

    else

      echo "ERROR: The destination container parameter not provided"
      exit 1
    fi
  
  else

    echo "ERROR: Docker container parameter not provided"
    exit 1
  fi

else

  echo "ERROR: File parameter not provided"
  exit 1
fi