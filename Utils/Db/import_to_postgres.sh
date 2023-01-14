#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_POSTGRES="$HERE/get_postgres.sh"

if [ -n "$1" ]; then

  DB="$1"

else

  echo "ERROR: Database parameter not provided"
  exit 1
fi

if [ -n "$2" ]; then

  SQL_FILE="$2"

else

  echo "ERROR: SQL file parameter not provided"
  exit 1
fi

if sh "$SCRIPT_GET_POSTGRES" "$DB"; then

  if test -e "$SQL_FILE"; then

    echo "ERROR: Implementation not completed"
    exit 1

  else

    echo "ERROR: File does not exist: $SQL_FILE"
    exit 1
  fi
fi


