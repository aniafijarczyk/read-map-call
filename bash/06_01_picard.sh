#!/bin/bash


SAMPLE=${1}

if [ -f "./04_bwa/${SAMPLE}_sorted.bam" ]; then
picard MarkDuplicates I=./04_bwa/${SAMPLE}_sorted.bam O=./06_rmdup/${SAMPLE}_rmdup.bam M=./06_rmdup/${SAMPLE}_picard.metrics REMOVE_DUPLICATES=true

fi
