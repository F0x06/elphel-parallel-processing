#!/bin/bash
#
# elphel-parallel-processing - Elphel camera array images post processing using GNU parallel
#
# Copyright (c) 2014 FOXEL SA - http://foxel.ch
# Please read <http://foxel.ch/license> for more information.
#
#
# Author(s):
#
#      Luc Deschenaux <l.deschenaux@foxel.ch>
#
#
# This file is part of the FOXEL project <http://foxel.ch>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Additional Terms:
#
#      You are required to preserve legal notices and author attributions in
#      that material or in the Appropriate Legal Notices displayed by works
#      containing it.
#
#      You are required to attribute the work as explained in the "Usage and
#      Attribution" section of <http://foxel.ch/license>.

set -e

FIJI=ImageJ-linux64

if [ $# -lt 1 ] ; then
  echo "usage: $(basename $0) <eyesis_correction_xml> [ <memory> ]"
  exit 1
fi

XML="$1"
DESTDIR=$(grep CORRECTION_PARAMETERS.resultsDirectory $XML | sed -r -n -e 's/.*CORRECTION_PARAMETERS.resultsDirectory\">([^<]+).*/\1/p')
PROCESSED_LIST="$DESTDIR/processed.txt"

MEM="$2"
[ -z "$MEM" ] && MEM="7150m"

processed_list_update() {
  inotifywait -m -e close_write $DESTDIR | while read EVENT ; do
    sed -r -n -e 's/.* ([0-9_]{18})-([0-9]{2})-.*EQR.tiff$/\1 \2/p' |
    while read EQR ; do
      EQR=($EQR)
      IMG_TIMESTAMP=${EQR[0]}
      count=$(ls -1 $DESTDIR/$IMG_TIMESTAMP-* | wc -l)
      [ "$count" = "29" ] && echo $IMG_TIMESTAMP >> "$PROCESSED_LIST"
    done
  done
}

processed_list_update &
CHILD_PID=$!

trap "kill -9 $CHILD_PID" EXIT SIGINT SIGKILL SIGABRT

$FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction prefs=$XML 2>&1

