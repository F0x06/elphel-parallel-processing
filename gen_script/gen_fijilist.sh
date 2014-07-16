#!/bin/sh

# e4p_pprocessor - Eyesis 4Pi GNU Parallel Processor
#
# Copyright (c) 2013-2014 FOXEL SA - http://foxel.ch
# Please read <http://foxel.ch/license> for more information.
#
#
# Author(s):
#
#      Luc Deschenaux <l.deschenaux@foxel.ch>
#      Kevin Velickovic <k.velickovic@foxel.ch>
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

[ -n "$DEBUG" ] && set -x

if [ $# -lt 2 -o $# -gt 4 ] ; then
  echo "usage: $(basename $0) <eyesis_correction_xml> <source_dir> [ <results_dir>  <output_file> ]"
  exit 1
fi

XML="$1"
SRCDIR="$2"
DSTDIR="$3"
OUTPUT="$4"

[ -z "$CHANNELS" ] && CHANNELS=9
[ -z "$MEM" ] && MEM=8192m

getTimestamps() {
    cat "$FILELIST" | while read JP4 ; do
        echo $(basename $JP4) | sed -r -n -e 's/^([0-9]{10}_[0-9]{6})_.*/\1/p'
    done | sort -u
}

NOW=$(date +%s) # _%N

if [ -z "$OUTPUT" ] ; then
     OUTPUT="fiji-$NOW"
     ECHO=yes
fi

LOGDIR=logs/fiji
mkdir -p $LOGDIR
SCRIPT=scripts/fiji.sh
mkdir -p $SRCDIR/fiji

if [ -z "$FILELIST" ] ; then
  FILELIST="/tmp/filelist_$NOW.tmp"
  find "$SRCDIR" -maxdepth 1 -name \*.jp4 > $FILELIST
else
  echo "Using files listed in $FILELIST" 1>&2
fi

# FILELIST is also used in corrxml.sh
export FILELIST

#echo "-j1 --bf $SCRIPT --ungroup --sshloginfile .. --joblog logs/fiji/$NOW.log scripts/fiji.sh {} 8512m > logs/fiji/$NOW.out" > ~/.parallel/fiji-$NOW
echo "-j1 --bf $SCRIPT --ungroup --sshloginfile .." > ~/.parallel/fiji

echo "#!/usr/bin/parallel --shebang -J fiji --joblog logs/fiji/$NOW.log $SCRIPT {} $MEM | tee logs/fiji/$NOW.out" > "$OUTPUT"
getTimestamps | while read TIMESTAMP ; do
    OUTXML=$SRCDIR/fiji/${NOW}-$TIMESTAMP.xml
    corrxml.sh $XML $SRCDIR $DSTDIR $OUTXML $CHANNELS $TIMESTAMP
    echo $OUTXML
done >> "$OUTPUT"
chmod +x "$OUTPUT"

cat $OUTPUT

echo
echo "# saved in $OUTPUT" 1>&2
