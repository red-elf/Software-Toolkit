#!/bin/bash

if [ -z "$1" ]; then

    echo "ERROR: Please provide tehe port number as the argument"
    exit 1
fi

sudo netstat --all --program | grep "$1"