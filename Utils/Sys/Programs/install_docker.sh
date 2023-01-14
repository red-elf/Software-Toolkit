#!/bin/bash

HERE="$(dirname -- "${BASH_SOURCE[0]}")"
SCRIPT_CHECK_ALT_LINUX="$HERE/../Recipes/altlinux.sh"

if ! test -e "$SCRIPT_CHECK_ALT_LINUX"; then

  echo "ERROR: Script not found '$SCRIPT_CHECK_ALT_LINUX'"
  exit 1
fi

if sh "$SCRIPT_CHECK_ALT_LINUX"; then

  if sudo apt-get install docker-engine && \
    sudo apt-get install docker-ce && \
    sudo usermod "$USER" -aG docker && \
    sudo systemctl enable --now docker; then

    exit 0
  fi
fi

echo "ERROR: Docker was not installed"
exit 1
