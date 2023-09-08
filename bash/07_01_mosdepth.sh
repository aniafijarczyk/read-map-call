#!/bin/bash


SAMPLE=${1}

if [ -f "./06_rmdup/${SAMPLE}_rmdup.bam" ]; then
mosdepth --fast-mode --by 1000 ./07_depth/${SAMPLE} ./06_rmdup/${SAMPLE}_rmdup.bam

fi
