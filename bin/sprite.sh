#!/bin/bash

# The following bash script generates a SVG icons sprite
# from a folder of SVG files.
# More information on this idea on CSS-Tricks:
# https://css-tricks.com/svg-sprites-use-better-icon-fonts/
# https://css-tricks.com/svg-symbol-good-choice-icons/
# https://css-tricks.com/svg-use-external-source/

# 1. Generate `sprite.svg` from SVG files in current folder.
#    $ bin/sprite.sh
# 2. Generate `sprite.svg` from SVG files in `assets/images/icons`.
#    $ bin/sprite.sh assets/images/icons/*
# 3. Generate `_includes/icons.svg` from SVG files in `assets/images/icons`.
#    $ bin/sprite.sh assets/images/icons/* _includes/icons.svg
# 4. Generate `_includes/icons.svg` from SVG files in `assets/images/icons` with a view box of `0 0 16 16`.
#    $ bin/sprite.sh assets/images/icons/* _includes/icons.svg "0 0 16 16"
# 5. Generate `_includes/icons.svg` from SVG files in `assets/images/icons` with a view box of `0 0 16 16`, and `id` attributes prefixed with `i_`.
#    $ bin/sprite.sh assets/images/icons/* _includes/icons.svg "0 0 16 16" "i_"

TMP_FOLDER=.tmp
SVG_FILES=${1:-./*}              # Folder containing all SVG files
DEST_FILE=${2:-./sprite.svg}     # Destination file for the sprite
VIEWBOX_SIZE=${3:-"0 0 20 20"}   # Viewbox size for <symbol> icons
ICON_PREFIX=${4:-"icon-"}        # Prefix for icons `id` attribute
TMP_FILE=$TMP_FOLDER/sprite.tmp  # Temporary file for manipulation

# Clean up and start fresh
rm -rf $DEST_FILE && touch $DEST_FILE
rm -rf $TMP_FOLDER && mkdir $TMP_FOLDER && touch $TMP_FILE

# Iterate on the SVG files and wrap them in <symbol> with the
# appropriate id and viewbox attributes
for f in $SVG_FILES; do
  NAME=$(basename $f .svg)
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
