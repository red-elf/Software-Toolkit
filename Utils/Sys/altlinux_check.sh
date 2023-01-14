#!/bin/bash

if ls -l /etc/*release | grep altlinux > /dev/null; then 

    echo "Alt Linux OK" && exit 0
    
else 

    echo "Unsupported Linix distribution" && exit 1
fi