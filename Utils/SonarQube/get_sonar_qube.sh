#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"

DOCKER_IMAGE="sonarqube"
DOCKER_TAG="9.9.0-community"
DOCKER_CONTAINER="sonarqube"

echo "Docker image: $DOCKER_IMAGE"
echo "Docker tag: $DOCKER_TAG"
echo "Docker container: $DOCKER_CONTAINER"

if sh "$SCRIPT_GET_DOCKER" true; then

  CONTAINER_STATUS="$( docker container inspect -f '{{.State.Status}}' $DOCKER_CONTAINER )"

  if [ "$CONTAINER_STATUS" == "running" ]; then

    echo "SonarQube Docker container is running"

  else

    if [ "$CONTAINER_STATUS" == "exited" ]; then

      if docker container start "$DOCKER_CONTAINER"; then

        echo "SonarQube Docker container re-started"

      else

        echo "ERROR: SonarQube Docker container failed to re-start"
        exit 1
      fi

    else

      if docker run --name "$DOCKER_CONTAINER:$DOCKER_TAG" -d "$DOCKER_IMAGE"; then

        echo "Postgres Docker container started with the database"

      else

        echo "ERROR: SonarQube Docker container failed to start"
        exit 1
      fi

    fi
  fi
  
else

  echo "ERROR: No Docker installation available"
  exit 1
fi
