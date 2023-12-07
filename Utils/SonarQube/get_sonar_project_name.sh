#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_VERSION="$HERE/Version/version.sh"

if ! test -e "$SCRIPT_VERSION"; then

    echo "ERROR: Version file not found '$SCRIPT_VERSION'"
    exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_VERSION"

if [ -z "$VERSIONABLE_VERSION_PRIMARY" ]; then

    echo "ERROR: 'VERSIONABLE_VERSION_PRIMARY' variable not set"
    exit 1
fi

if [ -z "$VERSIONABLE_VERSION_SECONDARY" ]; then

    echo "ERROR: 'VERSIONABLE_VERSION_SECONDARY' variable not set"
    exit 1
fi

if [ -z "$VERSIONABLE_VERSION_PATCH" ]; then

    echo "ERROR: 'VERSIONABLE_VERSION_PATCH' variable not set"
    exit 1
fi

if [ -z "$VERSIONABLE_NAME_NO_SPACE" ]; then

    echo "ERROR: 'VERSIONABLE_NAME_NO_SPACE' variable not set"
    exit 1
fi

SONARQUBE_GROUP="${VERSIONABLE_NAME_NO_SPACE}"
SONARQUBE_PROJECT="${VERSIONABLE_NAME_NO_SPACE}_$VERSIONABLE_VERSION_PRIMARY.$VERSIONABLE_VERSION_SECONDARY.$VERSIONABLE_VERSION_PATCH"

export SONARQUBE_GROUP
export SONARQUBE_PROJECT