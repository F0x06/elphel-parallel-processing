#!/bin/sh
HOSTNAME=$(hostname)
while read l ; do
  echo $(date +%F_%r) $@ $PARALLEL_PID $PARALLEL_SEQ $HOSTNAME $l
done
