#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"

DB="database"

if [ -n "$1" ]; then

  DB="$1"
fi

USER="postgres"

if [ -n "$2" ]; then

  USER="$2"
fi

PASSWORD="$USER"

if [ -n "$3" ]; then

  PASSWORD="$3"
fi

# TODO: Refactor the Docker code to be used with any image

DOCKER_IMAGE="postgres"
DOCKER_CONTAINER="postgres.$DB"

if sh "$SCRIPT_GET_DOCKER" true; then

  if [ "$( docker container inspect -f '{{.State.Status}}' $DOCKER_CONTAINER )" == "running" ]; then

    echo "Postgres Docker container is running"

  else

    if docker run --name "$DOCKER_CONTAINER" -e POSTGRES_USER="$USER" -e POSTGRES_PASSWORD="$PASSWORD" -e POSTGRES_DB="$DB" -d "$DOCKER_IMAGE"; then

      echo "Postgres Docker container started"

    else

      echo "ERROR: Postgres Docker container failed to start"
      exit 1
    fi
  fi

  # TODO:
  echo "ERROR: Not implemented"
  exit 1

else

  echo "ERROR: No Docker installation available"
  exit 1
fi
