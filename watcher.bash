#!/usr/bin/env bash

set -e

ME="$(basename $0)"
TEMP_FILE_PREV="$(mktemp -t "$ME")" || exit 1
TEMP_FILE_NOW="$(mktemp -t "$ME")" || exit 1


# echo "write to 'prev' file at $(date)" > $TEMP_FILE_PREV
# echo "write to 'now file at $(date)" > $TEMP_FILE_PREV

echo prev file: $TEMP_FILE_PREV
echo  now file: $TEMP_FILE_NOW

watch_dir=~/sw/redactinator-o-matic/sample-images

find $watch_dir -type f | egrep -e '/[a-f0-9]{32}.' > $TEMP_FILE_PREV

echo -n '' > $TEMP_FILE_PREV # DEBUG: make diff show all files as new

find $watch_dir -type f | egrep -e '/[a-f0-9]{32}.' > $TEMP_FILE_NOW


diff $TEMP_FILE_PREV $TEMP_FILE_NOW \
	| grep '^> ' \
	| tee diff.out \
	| sed -e 's/^> //g' \
	| xargs ./redact-image.bash

