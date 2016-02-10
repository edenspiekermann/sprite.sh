#!/bin/bash

# The following bash script generates a SVG icons sprite
# from a folder of SVG files.
# More information on this idea on CSS-Tricks:
# https://css-tricks.com/svg-sprites-use-better-icon-fonts/
# https://css-tricks.com/svg-symbol-good-choice-icons/
# https://css-tricks.com/svg-use-external-source/

# Set configuration
SVG_FILES=$1                    # Folder containing all SVG files
DEST_FILE=sprite.svg            # Destination file for the sprite
VIEWBOX_SIZE="0 0 20 20"        # Viewbox size for <symbol> icons
ICON_PREFIX=icon-               # Prefix for icons `id` attribute
VERBOSE=NO                      # Enable the verbose console mode

shift

# Grabbing options
while [[ $# > 0 ]]; do
  key="$1"
  case $key in
    -o|--output)
    DEST_FILE="$2"
    shift
    ;;
    -v|--viewbox)
    VIEWBOX_SIZE="$2"
    shift
    ;;
    -p|--prefix)
    ICON_PREFIX="$2"
    shift
    ;;
    --verbose)
    VERBOSE=YES
    ;;
    *)
    ;;
  esac
  shift
done

echo_verbose ()
{
  if [ $VERBOSE == YES ]; then
    echo $1
  fi
}

# Clean up and start fresh
rm -rf $DEST_FILE

# Start the dest file
echo "<svg xmlns='http://www.w3.org/2000/svg' style='display: none;'>" > $DEST_FILE

# Iterate on the SVG files and wrap them in <symbol> with the
# appropriate id and viewbox attributes
for f in $SVG_FILES/*; do
  NAME=$(basename $f .svg)
  echo_verbose "Processing $f …"
  if [ -f $f ]; then
    echo "<symbol id='$ICON_PREFIX$NAME' viewbox='$VIEWBOX_SIZE'><title>$NAME</title>$(cat $f)</symbol>" >> $DEST_FILE
  fi
done

# End the dest file
echo "</svg>" >> $DEST_FILE

# Announce when it’s over
echo_verbose "File $DEST_FILE successfully generated."
