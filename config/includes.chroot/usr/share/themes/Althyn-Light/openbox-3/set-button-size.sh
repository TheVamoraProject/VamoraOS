#!/bin/sh
# Swap the active Openbox button masks to a different pixel size.
#
# Openbox sizes titlebar buttons from the title font
# (button_size = label_height - 2) and CLIPS any mask larger than that from
# the top-left corner -- it never scales them. So if the maximise square
# shows up as a bare corner, or the X as a single stroke, the masks are too
# big for your font and you want a smaller set here.
#
#   ./set-button-size.sh 8|10|12|14|16
#
# Then: openbox --reconfigure
set -e
size="$1"
dir="$(cd "$(dirname "$0")" && pwd)"
[ -d "$dir/masks/$size" ] || { echo "usage: $0 8|10|12|14|16"; exit 1; }
cp "$dir/masks/$size"/*.xbm "$dir/"
echo "button masks set to ${size}px"
