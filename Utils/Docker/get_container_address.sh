#!/bin/bash

$CONTAINER="$1"

docker inspect -f '{{ .NetworkSettings.IPAddress }}' "$CONTAINER"