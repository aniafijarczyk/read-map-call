#!/bin/bash

SAMPLE=${1}

gzip -d ${SAMPLE}.per-base.bed.gz
sh ../05_03_check_depth.sh ${SAMPLE}.per-base.bed
gzip -f ${SAMPLE}.per-base.bed
rm ${SAMPLE}.mosdepth.*.dist.txt
rm ${SAMPLE}.per-base.bed*
rm ${SAMPLE}.regions.bed*
