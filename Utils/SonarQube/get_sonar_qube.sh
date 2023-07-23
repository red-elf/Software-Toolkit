#!/bin/bash

if [ -n "$1" ]; then
  
  PARAM_SONARQUBE_NAME="$1"

else
  
  echo "ERROR: SonarQube name parameter is not provided"
  exit 1
fi

if [ -n "$2" ]; then
  
  PARAM_SONARQUBE_VOLUMES_ROOT="$2"

else
  
  echo "ERROR: SonarQube volume root parameter is not provided"
  exit 1
fi

if [ -n "$3" ]; then
  
  PARAM_SONARQUBE_PORT="$3"

else
  
  echo "ERROR: SonarQube port parameter is not provided"
  exit 1
fi

CURRENT="$(pwd)"
HERE="$(dirname -- "$0")"

FILE_DOCKER_COMPOSE="docker-compose.yml"
FILE_DOCKER_COMPOSE_PROTO="proto.$FILE_DOCKER_COMPOSE"

FILE_DOCKER_COMPOSE_PATH="$HERE/$FILE_DOCKER_COMPOSE"
FILE_DOCKER_COMPOSE_PROTO_PATH="$HERE/$FILE_DOCKER_COMPOSE_PROTO"

if ! test -e "$FILE_DOCKER_COMPOSE_PROTO_PATH"; then

  echo "ERROR: Not found Docker compose proto file '$FILE_DOCKER_COMPOSE_PROTO'"
  exit 1
fi

if test -e "$FILE_DOCKER_COMPOSE_PATH"; then

  if ! rm -f "$FILE_DOCKER_COMPOSE_PATH"; then
    
    echo "ERROR: Docker compose file was not removed '$FILE_DOCKER_COMPOSE_PATH'"
    exit 1
  fi
fi

if ! touch "$FILE_DOCKER_COMPOSE_PATH"; then

  echo "ERROR: Docker compose file was not created '$FILE_DOCKER_COMPOSE_PATH'"
  exit 1
fi

DIR_VOLUMES="_Volumes"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"
SCRIPT_GET_DOCKER_COMPOSE="$HERE/../Sys/Programs/get_docker_compose.sh"

DB="Sonarqube.$PARAM_SONARQUBE_NAME"
DB_USER="sonar"
DB_PASSWORD="sonarqube"
DB_DATA_DIRECTORY="$HERE/../../_Databases/Postgres/$DB"

DOCKER_IMAGE="sonarqube"
DOCKER_TAG="10.1.0-community"
DOCKER_CONTAINER_PREFIX="sonarqube"
DOCKER_CONTAINER="$DOCKER_CONTAINER_PREFIX.$PARAM_SONARQUBE_NAME"
DOKCER_IMAGE=$(echo "$DOCKER_CONTAINER" | tr '[:upper:]' '[:lower:]')

DIR_VOLUMES_FULL="$PARAM_SONARQUBE_VOLUMES_ROOT/$DOCKER_CONTAINER"

echo "Docker image: $DOCKER_IMAGE"
echo "Docker tag: $DOCKER_TAG"
echo "Docker container: $DOCKER_CONTAINER"

if sh "$SCRIPT_GET_DOCKER" true && sh "$SCRIPT_GET_DOCKER_COMPOSE" true; then

  # TODO: Check and restart all mandatory containers
  echo "Checking the container status for: $DOCKER_CONTAINER"
  CONTAINER_STATUS="$( docker container inspect -f '{{.State.Status}}' $DOCKER_CONTAINER )"

  if [ "$CONTAINER_STATUS" = "running" ]; then

    echo "SonarQube Docker container is running"

  else

    if sudo sysctl -w vm.max_map_count=524288 && sudo sysctl -w fs.file-max=131072; then

      echo "SonarQube start prepared"

    else

      echo "ERROR: SonarQube start prepare failed"
      exit 1
    fi

    if [ "$CONTAINER_STATUS" = "exited" ]; then

      if docker container start "$DOCKER_CONTAINER"; then

        echo "SonarQube Docker container re-started"

      else

        echo "ERROR: SonarQube Docker container failed to re-start"
        exit 1
      fi

    else

      if test -e "$DIR_VOLUMES_FULL"; then

        echo "WARNING: We are about to remove existing volumes directory structure at '$DIR_VOLUMES_FULL'"

        if ! sudo rm -rf "$DIR_VOLUMES_FULL"; then

          echo "ERROR: Could not remove '$DIR_VOLUMES_FULL'"
          exit 1
        fi
      fi

      if mkdir -p "$DIR_VOLUMES_FULL"; then

        echo "SonarQube volumes directory has been created: '$DIR_VOLUMES_FULL'"

      else

        echo "ERROR: SonarQube volumes directory has not been created '$DIR_VOLUMES_FULL'"
        exit 1
      fi

      echo "Processing the Docker compose proto file: '$FILE_DOCKER_COMPOSE_PROTO' -> '$FILE_DOCKER_COMPOSE'"

      if cp "$FILE_DOCKER_COMPOSE_PROTO_PATH" "$FILE_DOCKER_COMPOSE_PATH"; then

        d='\'

        if sed -i "s${d}{{SERVICE.SONAR_QUBE.NAME}}${d}$DOCKER_CONTAINER${d}" "$FILE_DOCKER_COMPOSE_PATH" && \
           sed -i "s${d}{{SERVICE.SONAR_QUBE.PORTS.PORT_EXPOSED}}${d}$PARAM_SONARQUBE_PORT${d}" "$FILE_DOCKER_COMPOSE_PATH" && \
           sed -i "s${d}{{SERVICE.DATABASE.PASSWORD}}${d}$DB_USER${d}" "$FILE_DOCKER_COMPOSE_PATH" && \
           sed -i "s${d}{{SERVICE.DATABASE.USER}}${d}$DB_PASSWORD${d}" "$FILE_DOCKER_COMPOSE_PATH" && \ 
           sed -i "s${d}{{DIR.VOLUMES}}${d}$DIR_VOLUMES_FULL${d}" "$FILE_DOCKER_COMPOSE_PATH"; then
          
          echo "Docker compose proto file '$FILE_DOCKER_COMPOSE_PROTO' has been processed into '$FILE_DOCKER_COMPOSE'"

        else

          echo "ERROR: Failed to process Docker compose proto file '$FILE_DOCKER_COMPOSE_PROTO'"
          exit 1
        fi

      else

        echo "ERROR: Could not copy $FILE_DOCKER_COMPOSE_PROTO -> $FILE_DOCKER_COMPOSE"
        exit 1
      fi

      FILE_DOCKER_COMPOSE_PATH_FULL="$CURRENT/$FILE_DOCKER_COMPOSE_PATH"

      if ! test -e "$FILE_DOCKER_COMPOSE_PATH_FULL"; then

        echo "ERROR: Docker compose file not found '$FILE_DOCKER_COMPOSE_PATH_FULL'"
        exit 1
      fi

      if docker network inspect "$DOCKER_CONTAINER" >/dev/null 2>&1 || docker network create "$DOCKER_CONTAINER"; then

        echo "Docker network '$DOCKER_CONTAINER' is already available"

      else

        exit "ERROR: Docker network '$DOCKER_CONTAINER' creation failed"
        exit 1
      fi

      if docker-compose -f "$FILE_DOCKER_COMPOSE_PATH_FULL" up; then

        echo "Docker compose executed with success"

      else

        echo "ERROR: Docker compose failed"
        exit 1
      fi
    fi
  fi
  
else

  echo "ERROR: No mandatory installations available on the system"
  exit 1
fi
