#!/bin/bash

filename="$1"
extension="${filename##*.}"
speed="1.6"
newfile="$filename.fast.$speed.$extension"

if [ "$2" != '' ]
then
  speed="$2"
fi

if [ -f "$newfile" ]
then
  echo 'This file has already been sped up!'
  exit 1
fi

ffmpeg -i "$filename" -filter:a "atempo=$speed" -map 0:a -map_metadata -1 "$newfile" || exit $?

mv "$filename" "$filename.orig"
