#!/bin/sh

FIJI=ImageJ-linux64

if [ $# -ne 2 ] ; then
  echo "usage: $(basename $0) <eyesis_correction_xml> <memory>"
  exit 1
fi

XML="$1"
MEM="$2"

exec $FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction prefs=$XML 2>&1
