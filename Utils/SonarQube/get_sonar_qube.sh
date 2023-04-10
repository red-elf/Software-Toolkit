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

        # TODO: First time run
        
        if docker run --rm \
          -d --name "$DOCKER_CONTAINER" \
          -p 9000:9000 \
          -v sonarqube_extensions:/opt/sonarqube/extensions \
          "$DOCKER_CONTAINER:$DOCKER_TAG"; then

          ELAPSED=0

          while ! docker logs "$DOCKER_CONTAINER" | grep "SonarQube is operational";
          do
              
              sleep 1
              ELAPSED=$((ELAPSED + 1))

              if [ $ELAPSED == 60 ]; then

                echo "ERROR: Timeout"
                exit 1
              fi
          done

          if docker container stop "$DOCKER_CONTAINER"; then

            # TODO: 
            # - Rnable elastic search
            # - Generate .yml file for docker compose based on example.yml and use it
            # 
            sleep 5 && \
              docker run -d --name sonarqube \
                -p 9000:9000 \
                -e SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar \
                -e SONAR_JDBC_USERNAME=sonar \
                -e SONAR_JDBC_PASSWORD=sonar \
                -v sonarqube_data:/opt/sonarqube/data \
                -v sonarqube_extensions:/opt/sonarqube/extensions \
                -v sonarqube_logs:/opt/sonarqube/logs \
                "$DOCKER_CONTAINER"

            echo "SonarQube Docker container started"

          else

            echo "ERROR: Could not stop $DOCKER_CONTAINER container"
            exit 1
          fi

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
