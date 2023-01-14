#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_GET_PROGRAM="$HERE/get_program.sh"

if ! sh "$SCRIPT_GET_PROGRAM" docker; then

  echo "We are about to install Docker"
fi
