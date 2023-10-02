#!/bin/bash

SCRIPT_DOWNLOAD_FILE="$SUBMODULES_HOME/Software-Toolkit/Utils/download_file.sh"

if test -e "$SCRIPT_DOWNLOAD_FILE"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_DOWNLOAD_FILE"

else

    echo "ERROR: Script not found '$SCRIPT_DOWNLOAD_FILE'"
    exit 1
fi

DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"
DIR_APPS="$DIR_HOME/Apps/SonarScanner"

if test -e "$DIR_APPS"; then

  if ! rm -rf "$DIR_APPS"; then

    echo "ERROR: Could not remove '$DIR_APPS'"
    exit 1
  fi
fi

if ! test "$DIR_APPS"; then

  if ! mkdir -p "$DIR_APPS"; then

    echo "ERROR: Could not create directory '$DIR_APPS'"
    exit 1
  fi
fi

FILE_ZSH_RC="$DIR_HOME/.zshrc"
FILE_BASH_RC="$DIR_HOME/.bashrc"

DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip"

FILE_RC=""
DAY_CODE=$(date +%Y.%m.%d)
FILE_ARCHIVE="$DIR_DOWNLOADS/sonar-scanner_$DAY_CODE.zip"
    
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

if ! test -e "$DIR_DOWNLOADS"; then

    echo "ERROR: Downloads directory does not exist '$DIR_DOWNLOADS'"
    exit 1
fi

DOWNLOAD_FILE "$DOWNLOAD_URL" "$FILE_ARCHIVE"
EXTRACT_INTO "$FILE_ARCHIVE" "$DIR_APPS"

DIR_BIN=$(find "$DIR_APPS" -type d -name 'bin' -print -quit)
BIN_SCANNER="$DIR_BIN/sonar-scanner"

if test -e "$BIN_SCANNER"; then

  echo "SonarScanner binary: $BIN_SCANNER"

  # echo "Installing to opt..."
  # if [ -d "/var/opt/sonar-scanner-4.7.0.2747-linux" ];then
  #     sudo rm -rf /var/opt/sonar-scanner-4.7.0.2747-linux
  # fi
  # sudo mv sonar-scanner-4.7.0.2747-linux /var/opt

  # echo "Installation completed successfully."

  # echo "You can use sonar-scanner!"

else

  echo "ERROR: SonarScanner binarry no found at '$BIN_SCANNER'"
  exit 1
fi

