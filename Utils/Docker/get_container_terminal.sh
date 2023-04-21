#!/bin/bash

if [ -n "$1" ]; then

  docker exec -it "$1" bash

else

  echo "ERROR: Docker container parameter not provided"
  exit 1
fi