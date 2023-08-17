#!/bin/bash

SRA=SRR392813
SAMPLE=CALB0456

# Download fastq
echo "**************"
echo "DOWNLOAD FASTQ"
echo "**************"

source run_download.sh $SRA $SAMPLE

# Run mapping
echo "***************"
echo "** MAP READS **"
echo "***************"

source run_map.sh config_${SAMPLE}_${SRA}_PE.txt
