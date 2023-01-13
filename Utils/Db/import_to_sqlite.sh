#!/bin/bash

SCRIPT_GET_SQLITE="get_sqlite.sh"

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

if sh "$SCRIPT_GET_SQLITE" "$DB"

  if cat "$SQL_FILE" | sqlite3 "$DB"; then

    echo "'$SQL_FILE' imported into '$DB'"

  else

    echo "ERROR: '$SQL_FILE' not imported into '$DB'"
    exit 1
  fi
fi
