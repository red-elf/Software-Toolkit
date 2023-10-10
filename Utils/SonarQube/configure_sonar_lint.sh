#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPE_SETTINGS_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/settings.json.sh"

if [ -n "$1" ]; then

  RECIPE_SETTINGS_JSON="$1"
fi

if test -e "$RECIPE_SETTINGS_JSON"; then

  echo "Settings.json recipe: '$RECIPE_SETTINGS_JSON'"

else

  echo "ERROR: Recipe not found '$RECIPE_SETTINGS_JSON'"
  exit 1
fi

echo "ERRO: Not yet implemented"
exit 1