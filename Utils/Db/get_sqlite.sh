#!/bin/bash

DB="database.sqlite"

if [ -n "$1" ]; then

  DB="$1"
fi

if test -e "$DB"; then

  echo "Database is available: '$DB'"

else

  if echo "Initializing database: '$DB'" && sqlite3 "$DB" "VACUUM;" && test -e "$DB"; then

    echo "Database is initialized: '$DB'"

  else

    echo "ERROR: database is not initialized: '$DB'"
    exit 1
  fi
fi
