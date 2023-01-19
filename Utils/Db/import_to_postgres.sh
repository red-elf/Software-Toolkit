#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_POSTGRES="$HERE/get_postgres.sh"
SCRIPT_PUSH_TO_CONTAINER="$HERE/../Docker/push_file_to_container.sh"

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

    CONTAINER="postgres.$DB"

    if sh "$SCRIPT_PUSH_TO_CONTAINER" "$SQL_FILE" "$CONTAINER"; then

      JUST_FILE="${SQL_FILE##/*/}"

      echo "'$SQL_FILE' ($JUST_FILE) pushed into '"$CONTAINER"' container"

      if docker exec -i "$CONTAINER" psql -U "$USER" -d "$DB" < "$JUST_FILE"; then

        echo "'$JUST_FILE' imported into '$DB' database"

      else

        echo "ERROR: '$SQL_FILE' not imported into '$DB' database"
        exit 1
      fi

    else

      echo "ERROR: '$SQL_FILE' not pushed into '"$CONTAINER"' container"
      exit 1
    fi
    
  else

    echo "ERROR: File does not exist: $SQL_FILE"
    exit 1
  fi
fi


