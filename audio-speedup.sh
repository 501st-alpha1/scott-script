#!/bin/bash

filename="$1"
speed="1.5"
newfile="$filename.fast.mp3"

if [ "$2" != '' ]
then
  speed="$2"
fi

ffmpeg -i "$filename" -filter:a "atempo=$speed" "$newfile"
