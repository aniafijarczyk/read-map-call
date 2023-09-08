#!/bin/bash

SAMPLE=${1}

if [ -f "./06_rmdup/${SAMPLE}_rmdup.bam" ]; then
samtools index 06_rmdup/${SAMPLE}_rmdup.bam

fi
