#!/bin/bash

SAMPLE=${1}
SRA=${2}

for FQ in ${SAMPLE}_${SRA}*.fastq.gz
  do
  FQ_NAME=$(echo $FQ | sed 's/.fastq.gz//g' | sed 's/.fq.gz//g')
  echo ${FQ_NAME}
  # Get read lengths
  seqkit stats ${FQ} -o "stats_"${FQ_NAME}".txt"
  done
