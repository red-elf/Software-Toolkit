#!/bin/bash

RUN_CURL() {

  CURL_UTIL_PORT="80"
  CURL_UTIL_ENDPOINT=""
  CURL_UTIL_HOST="127.0.0.1"
  CURL_UTIL_PROTOCOL="https"

  if [ -n "$1" ]; then

    CURL_UTIL_PROTOCOL="$1"
  fi

  if [ -n "$2" ]; then

    CURL_UTIL_HOST="$2"
  fi

  if [ -n "$3" ]; then

    CURL_UTIL_PORT="$3"
  fi

  if [ -n "$4" ]; then

    CURL_UTIL_ENDPOINT="$4"
  fi

  PORT_APPENDIX=":$CURL_UTIL_PORT"
  
  if [ CURL_UTIL_PORT = "80" ]; then

    PORT_APPENDIX=""
  fi

  TARGET="$CURL_UTIL_PROTOCOL"://"$CURL_UTIL_HOST""$PORT_APPENDIX"/"$CURL_UTIL_ENDPOINT"
  
  echo "URL to execure: $TARGET" && curl -v "$TARGET" && echo ""
}