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

# check whether timestamp already processed
checkeqrcount() {
  EQRCOUNT=0
  HALFEQRCOUNT=0
  for ((i=0; i<$SUBCAMERAS; ++i)) ; do
    CHAN=$(printf %02d $i)
    # find is too slow, use test instead
    test -e $DESTDIR/${TIMESTAMP}-${CHAN}-DECONV-RGB24_EQR.tiff && ((++EQRCOUNT))
    test -e $DESTDIR/${TIMESTAMP}-${CHAN}-DECONV-RGB24_EQR-LEFT.tiff &&
    test -e $DESTDIR/${TIMESTAMP}-${CHAN}-DECONV-RGB24_EQR-RIGHT.tiff && ((++EQRCOUNT))
  done
  test $EQRCOUNT == $SUBCAMERAS
}

[ -n "$DEBUG" ] && set -x

[ -z "$FIJI" ] && FIJI=ImageJ-linux64

if [ $# -lt 1 ] ; then
  echo "usage: $(basename $0) <eyesis_correction_xml> [ <memory> ]"
  exit 1
fi

IMAGEJ_ELPHEL_XML="$1"
MEM="$2"
[ -z "$MEM" ] && MEM="7150m"

DESTDIR=$(grep CORRECTION_PARAMETERS.resultsDirectory $IMAGEJ_ELPHEL_XML | sed -r -e 's/.*>([^<]+).*/\1/')
BASE=$(basename $IMAGEJ_ELPHEL_XML)
TIMESTAMP=${BASE:11:17}

# TODO: pass SUBCAMERAS in post_processing generated shebang, from XML property CAMERAS.channelMap.length
SUBCAMERAS=$(grep CAMERAS.channelMap.length $IMAGEJ_ELPHEL_XML | sed -r -e 's/.*>([^<]+).*/\1/')

# assume there's only 1 timestamp in the XML
echo check whether $TIMESTAMP is already processed
if checkeqrcount ; then
  echo already processed: $TIMESTAMP
  exit 0
fi

echo process $TIMESTAMP
$FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction prefs=$IMAGEJ_ELPHEL_XML 2>&1

echo check whether $TIMESTAMP has been thoroughly processed
if ! checkeqrcount ; then
  echo ERROR: $((EQRCOUNT+HALFEQRCOUNT/2))/$SUBCAMERAS channels have been processed for $TIMESTAMP
  exit 240
fi

echo successfully processed $TIMESTAMP
