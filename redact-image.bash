#!/usr/bin/env bash

set -e

ME='redact-image.bash'

function usage {
	print "Usage: $ME image_file [image_file ...]"
}

function help {
	usage
	echo ''
	echo "Alter an image, or set of images, and save the altered files as:"
	echo "  <original-name>_Redacted.ext"
	echo ''
	echo "Overwrites files in the case of a naming conflict and will not process"
	echo "  filenames containing '_Redacted'"
	echo ''
	echo "Errors out if supplied files do not exist or are not images"
	echo ''
	echo "You feed this script image files, and it creates a matching"
	echo "\`_Redacted' image for each original. The \`_Redacted' version"
	echo "has a 50% opacity black layer placed over the original image and white"
	echo "text on top of that says \`REDACTED AS:' and the new filename; i.e.,"
	echo "the \`_Redacted' version is meaningfully visually different."
}

if [[ $# -lt 1 ]]
then
	echo "error: must supply 1 argument" 1>&2
	usage 1>&2
	exit 1
fi

og_args="$@"
error_count=0
while [[ $# -gt 0 ]]
do
	if ! [[ -e "$1" ]]
	then
		echo "error: '$1' file does not exist" 1>&2
		error_count=$(( $error_count + 1 ))
	fi

	shift
done

if [[ $error_count -gt 0 ]]
then
	echo "encountered input errors; bailing" 1>&2
	exit 2
fi

set -- $og_args

error_count=0
while [[ $# -gt 0 ]]
do
	og_filename="$1"

	if ! identify -format '%W %H' "$og_filename" > /dev/null
	then
		echo "error: could not read width & height of: '$og_filename' (is it an image?)" 1>&2
		error_count=$(( $error_count + 1 ))
	fi
	shift
done

if [[ $error_count -gt 0 ]]
then
	echo "encountered input errors; bailing" 1>&2
	exit 3
fi

set -- $og_args

error_count=0
while [[ $# -gt 0 ]]
do
	og_filename="$1"
	new_filename="$(echo "$og_filename" | sed -e 's/\.\([A-Za-z][A-Za-z]*\)$/_Redacted.\1/')"

	if echo "$new_filename" | grep -q '_Redacted_Redacted'
	then
		echo "skipping: '$og_filename'"
		shift
		continue
	fi

	width=$(identify -format %W "$og_filename")
	height=$(identify -format %H "$og_filename")

	convert \
		-background '#000A' \
		-gravity center \
		-fill white \
		-size "${width}x${height}" \
			caption:"REDACTED AS:\\n$new_filename" \
			"$og_filename" \
			+swap \
		-gravity center \
		-composite "$new_filename"

	shift
done
