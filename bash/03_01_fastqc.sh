#!/bin/bash

#Read variables from config
. ${1}

fq=$(ls 02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz 02_trimmed/${SAMPLE}_SE.fastq.gz)
fastqc $fq -o output2_${SAMPLE} -t ${FASTQC_THREADS}
