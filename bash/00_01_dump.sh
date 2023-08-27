#!/bin/bash

SAMPLE=${1}
SRA=${2}


### Checking size ( 7x for the output and 6x for the temp files)
vdb-dump --info ${SRA} > ./00_sra/size_${SAMPLE}_${SRA}.txt
grep 'size' ./00_sra/size_${SAMPLE}_${SRA}.txt
fasterq-dump --split-3 -t ./ -o ${SAMPLE}_${SRA} -O 00_sra -e 6 -f ${SRA}
