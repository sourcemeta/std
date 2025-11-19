#!/bin/sh

set -o errexit
set -o nounset

DATA="$(pwd)/DATA"

while read -r line
do
  DESTINATION="$(echo "$line" | cut -d ' ' -f 1)"
  URL="$(echo "$line" | cut -d ' ' -f 2)"
  echo "Fetching $DESTINATION => $URL" 1>&2
  mkdir -p "$(dirname "$DESTINATION")"
  EXTENSION="${URL##*.}"
  if [ "$EXTENSION" = "zip" ]
  then
    echo "-- Decompressing ZIP file" 1>&2
    rm -rf "$DESTINATION"
    curl --location --output "$DESTINATION.zip" "$URL"
    mkdir -p "$DESTINATION"
    bsdtar -xf "$DESTINATION.zip" -C "$DESTINATION" --no-same-permissions
    rm "$DESTINATION.zip"
  else
    curl --location --output "$DESTINATION" "$URL"
  fi
done < "$DATA"
