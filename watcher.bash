#!/usr/bin/env bash

set -e

ME="$(basename $0)"
TEMP_FILE_PREV="$(mktemp -t "$ME")" || exit 1
TEMP_FILE_NOW="$(mktemp -t "$ME")" || exit 1


echo "write to 'prev' file at $(date)" > $TEMP_FILE_PREV
echo "write to 'now file at $(date)" > $TEMP_FILE_PREV

echo prev file: $TEMP_FILE_PREV
echo  now file: $TEMP_FILE_NOW
