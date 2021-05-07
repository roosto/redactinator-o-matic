#!/usr/bin/env bash

set -e

ME="$(basename $0)"
TEMP_FILE_PREV="$(mktemp -t "$ME")" || exit 1
TEMP_FILE_NOW="$(mktemp -t "$ME")" || exit 1

WATCH_INTERVAL_IN_SECONDS=15

# was script invoked correctly?
if [[ $# -ne 1 ]]
then
	if [[ $# -eq 0 ]]
	then
		echo "$ME: error: missing watch_dir argument" 1>&2
	else
		echo "$ME: error: too many arguments" 1>&2
	fi

	echo "Usage: $ME watch_dir" 1>&2
	exit 1
fi

# is cli arg is valid?
watch_dir="$1"
if ! [[ -d $watch_dir ]]
then
	echo "$ME: error: \`$watch_dir' is not a directory" 1>&2
	exit 2
fi

if ! [[ -r $watch_dir ]]
then
	echo "$ME: error: \`$watch_dir' is not readable" 1>&2
	exit 3
fi

watch_dir="$1"

find $watch_dir -type f | egrep -e '/[a-f0-9]{32}.' > $TEMP_FILE_PREV

echo -n '' > $TEMP_FILE_PREV # DEBUG: make diff show all files as new

find $watch_dir -type f | egrep -e '/[a-f0-9]{32}.' > $TEMP_FILE_NOW

while true
	if diff $TEMP_FILE_PREV $TEMP_FILE_NOW &> /dev/null
	then
		sleep $WATCH_INTERVAL_IN_SECONDS
	else
		diff $TEMP_FILE_PREV $TEMP_FILE_NOW \
		 | grep '^> ' \
		 | tee diff.out \
		 | sed -e 's/^> //g' \
		 | xargs ./redact-image.bash
	fi

	echo "$ME: watching \`$watch_dir' for new image files to redact. (^C to interrupt)"
done
