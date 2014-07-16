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

if [ "$#" -ne 5 ] ; then
     echo "Usage: $(basename $0) <Source directory> <Destination Directory> <Black point> <White point> <Quality>"
     exit 1
fi

SRCDIR="$1"
DSTDIR="$2"
BLACKPOINT="$3"
WHITEPOINT="$4"
QUALITY="$5"

getTimestamps() {
    find "$SRCDIR" -maxdepth 1 -name \*.tiff | while read TIFF ; do
        echo $(basename $TIFF) | sed -r -n -e 's/^([0-9]{10}_[0-9]{6})-.*/\1/p'
    done | sort -u
}

NOW=$(date +%s) # _%N

LOGDIR=logs/stitch/$NOW
mkdir -p logs/stitch
SCRIPT=scripts/stitch.sh

echo "--bf $SCRIPT --ungroup --sshloginfile .. --joblog logs/stitch/$NOW.log scripts/stitch.sh $LOGDIR $SRCDIR $DSTDIR {} $QUALITY ${BLACKPOINT}%,${WHITEPOINT}%,1" > ~/.parallel/stitch-$NOW

echo "#!/usr/bin/parallel --shebang -J stitch-$NOW"
    getTimestamps | while read TIMESTAMP ; do
    echo $TIMESTAMP
done

