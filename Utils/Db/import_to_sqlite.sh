#!/bin/bash

HERE="$(dirname -- "$0")"
SCRIPT_GET_SQLITE="$HERE/get_sqlite.sh"

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

if bash "$SCRIPT_GET_SQLITE" "$DB"; then

  if test -e "$SQL_FILE"; then

    # shellcheck disable=SC2002
    if cat "$SQL_FILE" | sqlite3 "$DB"; then

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


