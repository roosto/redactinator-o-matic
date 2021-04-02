# `redact-image.bash` #

## RMD Redaction Tool Testing Helper ##

This script is useful when working with the RMD redaction tool.

The script will create visually different images that also conform to filenaming conventions expected by the redaction tool.

## How to Use ##

The below text is the output of the `--help` from the script:

----

    Usage: redact-image.bash image_file [image_file ...]

    Alter an image, or set of images, and save the altered files as:
      <original-name>_Redacted.ext

    Overwrites files in the case of a naming conflict and will not process
      filenames containing '_Redacted'

    Errors out if supplied files do not exist or are not images

    You feed this script image files, and it creates a matching
    `_Redacted' image for each original. The `_Redacted' version
    has a 50% opacity black layer placed over the original image and white
    text on top of that says `REDACTED AS:' and the new filename; i.e.,
    the `_Redacted' version is meaningfully visually different.
