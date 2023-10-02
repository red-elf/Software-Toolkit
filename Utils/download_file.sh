#!/bin/bash

DOWNLOAD_FILE() {

    if [ -z "$1" ]; then

        echo "Download URL parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "Download destination parameter is mandatory"
        exit 1
    fi

    DOWNLOAD_URL="$1"
    FILE_DOWNLOAD="$2"

    if test -e "$FILE_DOWNLOAD"; then

        echo "File has been already downloaded: '$FILE_DOWNLOAD'"
        
    else

        if wget "$DOWNLOAD_URL" -O "$FILE_DOWNLOAD"; then

            echo "File '$FILE_DOWNLOAD' has been downloaded with success"

        else

            echo "ERROR: '$FILE_DOWNLOAD' has failed to downloaded"
            exit 1
        fi
    fi
}

EXTRACT_INTO() {

    if [ -z "$1" ]; then

        echo "ERROR: Archive parameter is mandatory"
        exit 1
    fi

    if [ -z "$2" ]; then

        echo "ERROR: Destination parameter is mandatory"
        exit 1
    fi

    ARCHIVE="$1"
    DESTINATION="$2"

    if file --mime-type "$ARCHIVE" | grep -q zip$; then
    
        if unzip -d "$DESTINATION/" "$ARCHIVE"; then

            echo "Extracted '$ARCHIVE' into '$DESTINATION'"

        else

            echo "ERROR: Could not extract '$ARCHIVE' into '$DESTINATION'"
            exit 1
        fi

    else

        if file --mime-type "$ARCHIVE" | grep -q gz$; then

            if tar -xzf "$ARCHIVE" -C "$DESTINATION"; then

                echo "Extracted '$ARCHIVE' into '$DESTINATION'"

            else

                echo "ERROR: Could not extract '$ARCHIVE' into '$DESTINATION'"
                exit 1
            fi

        else

            echo "ERROR: Unsupported archive type for file '$ARCHIVE'"
            exit 1
        fi
    fi
}