#!/bin/bash

function GET_CONTAINER_ADDRESS {

    CONTAINER="$1"

    docker inspect -f '{{ .NetworkSettings.IPAddress }}' "$CONTAINER"
}