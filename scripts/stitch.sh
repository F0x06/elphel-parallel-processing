#!/bin/sh
set -e

SRCDIR=/data/rmll/Montpellier_20140617/Montpellier_av_run_1_imagej_processed
DSTDIR=/data/rmll/Montpellier_20140617/results
t=1403179789_224762
QUALITY=98
LEVELS="0%,100%,1"

LOGDIR=$1
[ -d "$LOGDIR" ] || mkdir -p $LOGDIR
shift

getParameters() {
     [ -n "$1" ] && SRCDIR=$1
     [ -n "$2" ] && DSTDIR=$2
     [ -n "$3" ] && t=$3
     [ -n "$4" ] && QUALITY=$4
     [ -n "$5" ] && LEVELS=$5
}

# needed because parallel --hashbong escape spaces
getParameters $@
LOGFILE=$LOGDIR/$t.log

{
     enblend-mp -w -o $DSTDIR/result_${t}_top.tif  $SRCDIR/${t}-12-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-13-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-14-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-15-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-08-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-09-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-10-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-11-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-12-DECONV-RGB24_EQR-LEFT.tiff

     enblend-mp -w -o $DSTDIR/result_${t}_mid.tif  $SRCDIR/${t}-04-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-05-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-06-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-07-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-00-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-01-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-02-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-03-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-04-DECONV-RGB24_EQR-LEFT.tiff

     enblend-mp -w -o $DSTDIR/result_${t}_bot.tif  $SRCDIR/${t}-20-DECONV-RGB24_EQR-RIGHT.tiff $SRCDIR/${t}-21-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-22-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-23-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-16-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-17-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-18-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-19-DECONV-RGB24_EQR.tiff $SRCDIR/${t}-20-DECONV-RGB24_EQR-LEFT.tiff

     enblend-mp --wrap='vertical' -o $DSTDIR/result_${t}.tif $DSTDIR/result_${t}_top.tif $DSTDIR/result_${t}_mid.tif $DSTDIR/result_${t}_bot.tif

     convert $DSTDIR/result_${t}.tif -level $LEVEL -quality $QUALITY $DSTDIR/result_${t}-0-25-1.jpeg

     rm $DSTDIR/result_${t}_top.tif
     rm $DSTDIR/result_${t}_mid.tif
     rm $DSTDIR/result_${t}_bot.tif

} 2>&1 | tee $LOGFILE 


