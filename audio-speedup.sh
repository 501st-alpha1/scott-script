#!/bin/bash

filename="$1"
extension="${filename##*.}"
# TODO: make default configurable.
speed="1.7"

if [ "$2" != '' ]
then
  speed="$2"
fi

newfile="$filename.fast.$speed.$extension"

if [ -f "$newfile" ]
then
  echo 'This file has already been sped up!'
  exit 1
fi

ffmpeg -i "$filename" -filter:a "atempo=$speed" -map 0:a -map_metadata -1 "$newfile" || exit $?

# TODO: make this not clobber outfile
mv "$filename" "$filename.orig"
