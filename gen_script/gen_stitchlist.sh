#!/bin/sh

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

