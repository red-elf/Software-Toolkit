#!/bin/bash

# TODO: Support multiple projects, merge to append instead of replacing
# Obtain all registered projects and generate JSON with populated arrays here.
#
cat << EOF
{
    "sonarlint.connectedMode.connections.sonarqube": [
        {
            "serverUrl": "$SONARQUBE_SERVER",
            "connectionId": "$SONARQUBE_PROJECT"
        }
    ],
    "sonarlint.connectedMode.project": {
        "connectionId": "$SONARQUBE_PROJECT",
        "projectKey": "$SONARQUBE_PROJECT"
    }
}
EOF