#!/bin/sh

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
