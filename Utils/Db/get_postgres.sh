#!/bin/bash

HERE="$(dirname -- "$0")"
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

DIRECTORY_DATA="/var/lib/postgresql/data/pgdata"

if [ -n "$4" ]; then

  DIRECTORY_DATA="$4"
fi

if test -e "$DIRECTORY_DATA"; then

  echo "Directory available $DIRECTORY_DATA"

else

  if mkdir -p "$DIRECTORY_DATA"; then

    echo "Directory created $DIRECTORY_DATA"

  else

    echo "ERROR: directory not created $DIRECTORY_DATA"
    exit 1
  fi
fi

echo "Postgres data directory: $DIRECTORY_DATA"

DOCKER_IMAGE="postgres"
DOCKER_CONTAINER="postgres.$DB"

echo "Docker image: $DOCKER_IMAGE"
echo "Docker container: $DOCKER_CONTAINER"

if sh "$SCRIPT_GET_DOCKER" true; then

  CONTAINER_STATUS="$( docker container inspect -f '{{.State.Status}}' $DOCKER_CONTAINER )"

  if [ "$CONTAINER_STATUS" = "running" ]; then

    echo "Postgres Docker container is running"

  else

    if [ "$CONTAINER_STATUS" = "exited" ]; then

      if docker container start "$DOCKER_CONTAINER"; then

        echo "Postgres Docker container re-started"

      else

        echo "ERROR: Postgres Docker container failed to re-start"
        exit 1
      fi

    else

      if docker run --name "$DOCKER_CONTAINER" -e POSTGRES_USER="$USER" -e POSTGRES_PASSWORD="$PASSWORD" \
        -e POSTGRES_DB="$DB" -e PGDATA="$DIRECTORY_DATA" -d "$DOCKER_IMAGE"; then

        echo "Postgres Docker container started with the database"

      else

        echo "ERROR: Postgres Docker container failed to start"
        exit 1
      fi

    fi
  fi
  
else

  echo "ERROR: No Docker installation available"
  exit 1
fi
