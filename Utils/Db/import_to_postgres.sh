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

if [ -n "$3" ]; then

  USER="$3"

else

  echo "ERROR: Postgres user not provided"
  exit 1
fi

if [ -n "$4" ]; then

  PASSWORD="$4"

else

  echo "ERROR: Postgres password not provided"
  exit 1
fi

if [ -n "$5" ]; then

  DIRECTORY_DATA="$5"

else

  echo "ERROR: Postgres data directory path not provided"
  exit 1
fi


if sh "$SCRIPT_GET_POSTGRES" "$DB" "$USER" "$PASSWORD" "$DIRECTORY_DATA"; then

  if test -e "$SQL_FILE"; then

    if docker exec -i "postgres.$DB" psql -U "$USER" -d "$DB" < "$SQL_FILE"; then

      echo "ERROR: Implementatin not completed (1)"
      exit 1

      echo "'$SQL_FILE' imported into '$DB' database"

    else

      echo "ERROR: '$SQL_FILE' not imported into '$DB' database"
      exit 1
    fi

  else

    echo "ERROR: File does not exist: $SQL_FILE"
    exit 1
  fi
fi


