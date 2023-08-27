#!/bin/bash


SAMPLE=${1}

mosdepth --fast-mode --by 1000 ./07_depth/${SAMPLE} ./06_rmdup/${SAMPLE}_rmdup.bam
