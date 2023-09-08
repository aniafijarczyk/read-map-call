#!/bin/bash

### Inputs
SRA=${1}
SAMP=${2}

### Dump fastq
echo "DUMP FASTQ"
mkdir -p 00_sra

source activate sratools
sh 00_01_dump.sh ${SAMP} ${SRA}
conda deactivate

### Gzip if not gzipped
echo "GZIP IF NOT DONE"

cd ./00_sra
sh ../00_02_check_gzip.sh ${SAMP} ${SRA}
cd ..

### Check if paired
echo "CHECK PAIRED AND SINGLE"
python 00_03_check_paired.py ${SAMP}_${SRA}

### Check lengths and encoding
echo "CHECK LENGTHS AND ENCODING"
source activate seqkit
cd ./00_sra
sh ../00_04_seqkit.sh ${SAMP} ${SRA}
sh ../00_05_check_encoding.sh ${SAMP} ${SRA}
cd ..
conda deactivate

### Create config for each sample pair or SE
echo "CREATE CONFIGS"
source activate mbio
python 00_06_get_configs.py ${SAMP} ${SRA} ./00_sra
conda deactivate



