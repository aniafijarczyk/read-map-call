#!/bin/bash

SAMPLE=${1}
SRA=${2}

for f in ${SAMPLE}_${SRA}*.*
  do
   if (file $f | grep -q compressed ) ; then
     echo "Yes, your file "${f}" is compressed"
   else gzip -f $f
   fi
  done
