#!/bin/bash

SCRIPT_DOWNLOAD_FILE="$SUBMODULES_HOME/Utils/download_file.sh"

if test -e "$SCRIPT_DOWNLOAD_FILE"; then

    # shellcheck disable=SC1090
    . "$SCRIPT_DOWNLOAD_FILE"

else

    echo "ERROR: Script not found '$DOWNLOAD_FILE'"
    exit 1
fi

DIR_HOME="$(readlink --canonicalize ~)"
DIR_DOWNLOADS="$DIR_HOME/Downloads"

FILE_ZSH_RC="$DIR_HOME/.zshrc"
FILE_BASH_RC="$DIR_HOME/.bashrc"

DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip"

FILE_RC=""
FILE_ARCHIVE="$DIR_DOWNLOADS/sonar-scanner.zip"
    
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

# EXTRACT_INTO "$FILE_ARCHIVE" "$DIR_DATA"

# echo "Installing to opt..."
# if [ -d "/var/opt/sonar-scanner-4.7.0.2747-linux" ];then
#     sudo rm -rf /var/opt/sonar-scanner-4.7.0.2747-linux
# fi
# sudo mv sonar-scanner-4.7.0.2747-linux /var/opt

# echo "Installation completed successfully."

# echo "You can use sonar-scanner!"