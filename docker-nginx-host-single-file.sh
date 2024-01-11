#!/bin/bash

# TODO: help
# TODO: check arg given

filename="$1"

# TODO: check file exists
# TODO: support files outside CWD
# TODO: convert to absolute path
fullpath="$(pwd)/$filename"

# TODO: optional custom port
docker run --rm --volume "$fullpath:/usr/share/nginx/html/$filename" --publish 8080:80 nginx
