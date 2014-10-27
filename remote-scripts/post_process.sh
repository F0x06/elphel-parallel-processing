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

#set -x

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

# assume there's only 9 jp4 in the xml and timestamp is TIMESTAMP
[ $(find $DESTDIR -name $TIMESTAMP\*.tiff | wc -l) -lt 29 ] || exit 0

exec $FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction prefs=$IMAGEJ_ELPHEL_XML 2>&1

