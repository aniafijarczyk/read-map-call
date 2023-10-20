#!/bin/bash

### Inputs
SRA=${1}
SAMP=${2}

# Part I - downloading fastq & creating config

source run_download.sh ${SRA} ${SAMP}

# Part II - mapping reads to reference

source run_map.sh ${SRA} ${SAMP}

# Part III - calling variants with bcftools

source run_call.sh ${SRA} ${SAMP}
