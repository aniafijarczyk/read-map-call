#!/bin/bash


SAMPLE=${1}

mosdepth --fast-mode --by 1000 ./05_depth/${SAMPLE} ./04_bwa/${SAMPLE}_sorted.bam
