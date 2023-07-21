#!/bin/bash

CURRENT="$(pwd)"
HERE="$(dirname -- "$0")"
GRADLE_VERSION="8.2.1"
DIR_INSTALLATION="/opt/gradle"
GRADLE_ZIP="gradle-$GRADLE_VERSION.zip"
DIR_HOME="$(eval echo ~$USER)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"
FILE_ZSH_RC="$DIR_HOME/.zshrc"
FILE_BASH_RC="$DIR_HOME/.bashrc"
SCRIPT_CHECK_ALT_LINUX="$HERE/../Recipes/altlinux.sh"
URL_GRADLE_INSTALL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip"

if [ -n "$1" ]; then

  GRADLE_VERSION="$1"
fi

if ! test -e "$SCRIPT_CHECK_ALT_LINUX"; then

  echo "ERROR: Script not found '$SCRIPT_CHECK_ALT_LINUX'"
  exit 1
fi

if sh "$SCRIPT_CHECK_ALT_LINUX"; then

  if ! test -e "$DIR_DOWNLOADS"; then

    echo "ERROR: No Downloads directory available to download the Gradle installation '$DIR_DOWNLOADS'"
    exit 1
  fi

  if test -e "$DIR_INSTALLATION"; then

    if ! sudo rm -rf "$DIR_INSTALLATION"; then

      echo "ERROR: Could not remove '$DIR_INSTALLATION'"
      exit 1
    fi
  fi

  if ! sudo mkdir -p "$DIR_INSTALLATION"; then

    echo "ERROR: Could not create '$DIR_INSTALLATION'"
    exit 1
  fi

  if ! test -e "$DIR_DOWNLOADS/$GRADLE_ZIP"; then

    if ! wget -O "$DIR_DOWNLOADS/$GRADLE_ZIP" "$URL_GRADLE_INSTALL"; then

      echo "ERROR: The Gradle installation failed to download"
      exit 1
    fi
  fi

  if cd "$DIR_DOWNLOADS" && test -e "$GRADLE_ZIP"  && \
    sudo unzip -d "$DIR_INSTALLATION" "$GRADLE_ZIP" && ls "$DIR_INSTALLATION" && \
    cd "$CURRENT"; then

    FILE_RC=""
    
    if test -e "$FILE_ZSH_RC"; then

      FILE_RC="$FILE_ZSH_RC"

    else

        if test -e "$FILE_BASH_RC"; then

          FILE_RC="$FILE_BASH_RC"

        else

          echo "ERROR: No '$FILE_ZSH_RC' or '$FILE_BASH_RC' found on the system"
          exit 1
        fi
    fi

    EXPORT_DIRECTIVE="export PATH=\${PATH}:$DIR_INSTALLATION/gradle-$GRADLE_VERSION/bin"

    if cat "$FILE_RC" | grep "$EXPORT_DIRECTIVE"; then

      echo "Gradle is already added into the system path"

    else

      if echo "" >> "$FILE_RC" && echo "$EXPORT_DIRECTIVE" >> "$FILE_RC"; then

        echo "Gradle is added into the system path"

      else

        echo "ERROR: Gradle was not added into the system path with success"
        exit 1
      fi
    fi

    exit 0
  fi
fi

echo "ERROR: Gradle was not installed"
exit 1
