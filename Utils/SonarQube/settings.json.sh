#!/bin/bash

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