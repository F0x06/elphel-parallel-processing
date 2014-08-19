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

if [ "$1" = "-stitch" ] ; then
  if [ $# -lt 3 ] ; then
    usage 1
  fi
  STITCH=1
  shift
  STITCH_DESTDIR=$1
  shift
fi

if [ $# -lt 1 ] ; then
  echo "usage: $(basename $0) [ -stitch <dest_dir> ] <eyesis_correction_xml> [ <memory> ]"
  exit 1
fi

XML="$1"
XML_TIMESTAMP=($(basename $XML | tr '.' ' '))
EQRDONE=$(dirname "$XML")/${XML_TIMESTAMP[0]}

MEM="$2"
[ -z "$MEM" ] && MEM="7150m"

stitch() {
  tee |
  awk '/Saving equirectangular/{print $NF}' |
  sed -r -n -e 's/.*\/([0-9_]{18})-([0-9]{2})-.*/\1 \2/p' |
  eqrdone |
  parallel stitch.sh  ## TODO: pass parameters ... 
}

eqrdone() {
  while read EQR ; do
    [ -z "$STITCH" ] && continue
    EQR=($EQR)
    TIMESTAMP=${EQR[0]}
    CHANNEL=${EQR[1]}
    echo $CHANNEL >> "$EQRDONE-$TIMESTAMP-EQR.txt"
    count=$(sort -u "$EQRDONE" | wc -l)
    [ "$count" = "29" ] && echo $TIMESTAMP
  done
}

exec $FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction prefs=$XML 2>&1 | tee | stitch
