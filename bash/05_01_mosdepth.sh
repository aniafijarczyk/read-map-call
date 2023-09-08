#!/bin/bash


SAMPLE=${1}

if [ -f "./04_bwa/${SAMPLE}_sorted.bam" ]; then
mosdepth --fast-mode --by 1000 ./05_depth/${SAMPLE} ./04_bwa/${SAMPLE}_sorted.bam
fi
