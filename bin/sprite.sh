#!/bin/bash

PROGNAME="${0##*/}"
SRC_FOLDER="."
DEST_FILE="sprite.svg"
ID_PREFIX=""
QUIET="0"

usage()
{
  cat <<EO
Usage: $PROGNAME [options]
Script to build a SVG sprite from a folder of SVG files.
Options:
EO
cat <<EO | column -s\& -t
  -h, --help       & Shows this help
  -q, --quiet      & Disables informative output
  -i, --input [dir] & Specifies input dir (current dir by default)
  -o, --output [file] & Specifies output file ("./sprite.svg" by default)
  -v, --viewbox [str] & Specifies viewBox attribute (parsed by default)
  -p, --prefix [str] & Specifies prefix for id attribute (none by default)
EO
}

echo_verbose ()
{
  if [ "$QUIET" == "0" ]; then
    echo "$1"
  fi
}

clean ()
{
  rm -rf "$DEST_FILE"
}

main ()
{
  for f in "$SRC_FOLDER"/*.svg; do
    if [ -f "$f" ]; then
      NAME="$(basename "$f" .svg)"
      VIEWBOX="${VIEWBOX_SIZE:-$(sed -n -E 's/.*viewBox="([^"]+)".*/\1/p' "$f")}"
      PRESERVEASPECTRATIO="$(sed -n -E 's/.*preserveAspectRatio="([^"]+)".*/\1/p' "$f")"
      ID="$(echo "$ID_PREFIX$NAME" | tr ' ' '-')"
      
      ATTRS="viewBox='$VIEWBOX'"
      if [[ !  -z  $PRESERVEASPECTRATIO  ]]; then
        ATTRS="$ATTRS preserveAspectRatio='$PRESERVEASPECTRATIO'"
      fi
    
      echo_verbose "Processing \`$f\` (\`$ATTRS\`)…"
      echo "<symbol id='$ID' $ATTRS>$(perl -pe 's/\s*?<\/??svg.*?>\s*?\n//gi' "$f")</symbol>" >> "$DEST_FILE"
    fi
  done

  if [ -f "$DEST_FILE" ]; then
    awk 'BEGIN{print "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" style=\"display:none\">"}{print}END{print "</svg>"}' "$DEST_FILE" > .spritesh && mv .spritesh "$DEST_FILE"
  fi
}

# Grabbing options
while [[ $# > 0 ]]; do
  key="$1"
  case "$key" in
    -h|--help)
      usage
      exit 0
      ;;
    -i|--input)
      SRC_FOLDER="$2"
      shift
      ;;
    -o|--output)
      DEST_FILE="$2"
      shift
      ;;
    -v|--viewbox)
      VIEWBOX_SIZE="$2"
      shift
      ;;
    -p|--prefix)
      ID_PREFIX="$2"
      shift
      ;;
    -q|--quiet)
      QUIET="1"
      ;;
    *)
      ;;
  esac
  shift
done

clean
main

if [ -f "$DEST_FILE" ]; then
  echo_verbose "File \`$DEST_FILE\` successfully generated."
else
  echo_verbose "Could not generated \`$DEST_FILE\`. Are there any SVG file in \`$SRC_FOLDER\` folder?"
fi
