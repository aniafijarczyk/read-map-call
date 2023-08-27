#!/bin/bash

#Read variables from config
. ${1}

fq=$(ls $PE1 $PE2 $SE)
fastqc $fq -o output_${SAMPLE} -t ${FASTQC_THREADS}
