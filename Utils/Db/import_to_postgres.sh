#!/bin/bash

HERE="$(dirname -- "$0")"
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


if bash "$SCRIPT_GET_POSTGRES" "$DB" "$USER" "$PASSWORD" "$DIRECTORY_DATA"; then

  if test -e "$SQL_FILE"; then

    CONTAINER="postgres.$DB"
    JUST_FILE="${SQL_FILE##*/}"

    if bash "$SCRIPT_PUSH_TO_CONTAINER" "$SQL_FILE" "$CONTAINER" && \
      sleep 2 && \
      docker exec -i "$CONTAINER" bash -c "test -e $JUST_FILE && psql -U $USER -d $DB -f $JUST_FILE"; then

      echo "'$JUST_FILE' imported into '$DB' database"

    else

      echo "ERROR: '$SQL_FILE' not imported into '$DB' database"
      exit 1
    fi
    
  else

    echo "ERROR: File does not exist: $SQL_FILE"
    exit 1
  fi
fi


