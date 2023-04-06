#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_DOCKER="$HERE/../Sys/Programs/get_docker.sh"

DOCKER_IMAGE="sonarqube"
DOCKER_TAG="10.0.0-community"
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

      if docker volume create --name sonarqube_data &&
        docker volume create --name sonarqube_logs &&
        docker volume create --name sonarqube_extensions; then

        echo "SonarQube volumes have been created"

        # TODO:
        #
        # Start the SonarQube container with the embedded H2 database:
        #
        # docker run --rm \
        # -p 9000:9000 \
        # -v sonarqube_extensions:/opt/sonarqube/extensions \
        # <image_name>
        #
        # Exit once SonarQube has started properly.
        # Copy the Oracle JDBC driver into sonarqube_extensions/jdbc-driver/oracle
        # Run the image with your database properties defined using the -e environment variable flag:
        # 
        # docker run -d --name sonarqube \
        # -p 9000:9000 \
        # -e SONAR_JDBC_URL=... \
        # -e SONAR_JDBC_USERNAME=... \
        # -e SONAR_JDBC_PASSWORD=... \
        # -v sonarqube_data:/opt/sonarqube/data \
        # -v sonarqube_extensions:/opt/sonarqube/extensions \
        # -v sonarqube_logs:/opt/sonarqube/logs \
        # <image_name>

        if docker run --rm \
          -d --name "$DOCKER_CONTAINER" \
          -p 9000:9000 \
          -v sonarqube_extensions:/opt/sonarqube/extensions \
          "$DOCKER_CONTAINER:$DOCKER_TAG"; then

          echo "SonarQube Docker container started"

        else

          echo "ERROR: SonarQube Docker container failed to start"
          exit 1
        fi

      else

        echo "ERROR: Creating SonarQube vloumes failed"
        exit 1
      fi
    fi
  fi
  
else

  echo "ERROR: No Docker installation available"
  exit 1
fi
