#!/bin/bash

# The following bash script generates a SVG icons sprite
# from a folder of SVG files.
# More information on this idea on CSS-Tricks:
# https://css-tricks.com/svg-sprites-use-better-icon-fonts/
# https://css-tricks.com/svg-symbol-good-choice-icons/
# https://css-tricks.com/svg-use-external-source/

SVG_FILES=$1 # Folder containing all SVG files
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

# Set configuration
TMP_FOLDER=.tmp
DEST_FILE=${DEST_FILE:-./sprite.svg}      # Destination file for the sprite
VIEWBOX_SIZE=${VIEWBOX_SIZE:-"0 0 20 20"} # Viewbox size for <symbol> icons
ICON_PREFIX=${ICON_PREFIX:-"icon-"}       # Prefix for icons `id` attribute
TMP_FILE=$TMP_FOLDER/sprite.tmp           # Temporary file for manipulation
VERBOSE=${VERBOSE:-NO}                    # Enable the verbose console mode

# Clean up and start fresh
rm -rf $DEST_FILE && touch $DEST_FILE
rm -rf $TMP_FOLDER && mkdir $TMP_FOLDER && touch $TMP_FILE

# Iterate on the SVG files and wrap them in <symbol> with the
# appropriate id and viewbox attributes
for f in $SVG_FILES/*; do
  NAME=$(basename $f .svg)
  if [ $VERBOSE == YES ]; then
    echo "Processing $f …"
  fi
  if [ -f $f ]; then
    (
      echo "<symbol id='$ICON_PREFIX$NAME' viewbox='$VIEWBOX_SIZE'>";
      echo "  <title>$NAME</title>";
      sed 's/^/  /' $f;
      echo "</symbol>";
    ) >> $DEST_FILE
  fi
done

# Wrap the sprite file with `<svg>`
(
  echo "<svg xmlns='http://www.w3.org/2000/svg' style='display: none;'>";
  sed 's/^/  /' $DEST_FILE;
  echo "</svg>"
) > $TMP_FILE && mv $TMP_FILE $DEST_FILE

# Announce when it’s over
echo "File $DEST_FILE successfully generated."
