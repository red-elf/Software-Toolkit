#!/bin/bash

if [ -n "$1" ]; then
  
  if [ -n "$2" ]; then
  
    docker cp --follow-link "$1" "$2":/
  
  else

    echo "ERROR: Docker container parameter not provided"
    exit 1
  fi

else

  echo "ERROR: File parameter not provided"
  exit 1
fi