#!/bin/bash
find $1 -depth -exec bash -c 'mv "$1" "$(dirname "$1")/$(basename "$1" | sed "s/\[SLIV\.ONE\]\s*//")"' _ {} \;
find $1 -type f -name "*.url" -exec rm -f {} +

