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

set -e

QUALITY=98
LEVELS="0%,100%,1"

SRCDIR=$1
DSTDIR=$2
TIMESTAMP=$3
[ -n "$4" ] && QUALITY=$4
[ -n "$5" ] && LEVELS=$5

t=$TIMESTAMP

[ -f DSTDIR/result_${t}-0-25-1.jpeg ] && exit 0

{
     enblend-mp -w -o $DSTDIR/result_${t}_top.tif  $SRCDIR/${t}-12-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-13-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-14-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-15-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-08-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-09-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-10-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-11-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-12-DECONV-RGB24_EQR-LEFT.tiff || exit 1

     enblend-mp -w -o $DSTDIR/result_${t}_mid.tif  $SRCDIR/${t}-04-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-05-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-06-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-07-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-00-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-01-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-02-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-03-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-04-DECONV-RGB24_EQR-LEFT.tiff || exit 1
     
     enblend-mp -w -o $DSTDIR/result_${t}_bot.tif  $SRCDIR/${t}-20-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-21-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-22-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-23-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-16-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-17-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-18-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-19-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-20-DECONV-RGB24_EQR-LEFT.tiff || exit 1

     enblend-mp --wrap='vertical' -o $DSTDIR/result_${t}.tif $DSTDIR/result_${t}_top.tif $DSTDIR/result_${t}_mid.tif $DSTDIR/result_${t}_bot.tif || exit 1

     convert $DSTDIR/result_${t}.tif -level $LEVELS -quality $QUALITY $DSTDIR/.result_${t}-0-25-1.jpeg || exit 1
     
     mv $DSTDIR/.result_${t}-0-25-1.jpeg $DSTDIR/result_${t}-0-25-1.jpeg

     rm $DSTDIR/result_${t}_top.tif
     rm $DSTDIR/result_${t}_mid.tif
     rm $DSTDIR/result_${t}_bot.tif

     echo $t >> $DSTDIR/stitched.txt

} 2>&1


