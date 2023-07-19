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

HERE="$(dirname -- "$0")"

DIR_VOLUMES="_Volumes"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"

DB="Sonarqube.$PARAM_SONARQUBE_NAME"
DB_USER="sonar"
DB_PASSWORD="sonarqube"
DB_DATA_DIRECTORY="$HERE/../../_Databases/Postgres/$DB"

DOCKER_IMAGE="sonarqube"
DOCKER_TAG="10.1.0-community"
DOCKER_CONTAINER_PREFIX="sonarqube"
DOCKER_CONTAINER="$DOCKER_CONTAINER_PREFIX.$PARAM_SONARQUBE_NAME"

DIR_VOLUMES_FULL="$PARAM_SONARQUBE_VOLUMES_ROOT/$DOCKER_CONTAINER"

echo "Docker image: $DOCKER_IMAGE"
echo "Docker tag: $DOCKER_TAG"
echo "Docker container: $DOCKER_CONTAINER"

if sh "$SCRIPT_GET_DOCKER" true; then

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

        if ! rm -rf "$DIR_VOLUMES_FULL"; then

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

      if mkdir -p "$DIR_VOLUMES_FULL/database" && chmod -R 777 "$DIR_VOLUMES_FULL/database" && \ 
        mkdir -p "$DIR_VOLUMES_FULL/data" && chmod -R 777 "$DIR_VOLUMES_FULL/data" && \
        mkdir -p "$DIR_VOLUMES_FULL/extensions" && chmod -R 777 "$DIR_VOLUMES_FULL/extensions" && \
        mkdir -p "$DIR_VOLUMES_FULL/logs" && chmod -R 777 "$DIR_VOLUMES_FULL/logs"; then

        echo "Volumes directories created and permissions set"

      else

        echo "ERROR: Could not create volumes directories and set permissions"
        exit 1
      fi

      # TODO: Docker compose
      #
      # if docker run --stop-timeout 3600 -d --name "$DOCKER_CONTAINER" \
      #   --ulimit nofile=65536:65536 \
      #   -p "0.0.0.0:$PARAM_SONARQUBE_PORT:9000" \
      #   -e "SONAR_JDBC_URL=jdbc:postgresql://$DOCKER_CONTAINER_IP:5432/$DB" \
      #   -e "SONAR_JDBC_USERNAME=$DB_USER" \
      #   -e "SONAR_JDBC_PASSWORD=$DB_PASSWORD" \
      #   -v "$DIR_VOLUMES_FULL/data:/opt/sonarqube/data" \
      #   -v "$DIR_VOLUMES_FULL/extensions:/opt/sonarqube/extensions" \
      #   -v "$DIR_VOLUMES_FULL/logs:/opt/sonarqube/logs" \
      #   "$DOCKER_CONTAINER_PREFIX:$DOCKER_TAG"; then

      #   echo "SonarQube Docker container started"

      # else

      #   echo "ERROR: SonarQube Docker container was not started"
      # fi
    fi
  fi
  
else

  echo "ERROR: No Docker installation available"
  exit 1
fi
