#!/bin/bash

### Inputs
SRA=${1}
SAMPLE=${2}

### Dump fastq
echo DUMP FASTQ
mkdir -p 00_sra

conda activate sratools
### Checking size ( 7x for the output and 6x for the temp files)
vdb-dump --info ${SRA} > ./00_sra/size_${SAMPLE}_${SRA}.txt
grep 'size' ./00_sra/size_${SAMPLE}_${SRA}.txt
### Dumping
fasterq-dump --split-3 -t ./ -o ${SAMPLE}_${SRA} -O 00_sra -e 6 -f ${SRA}
conda deactivate

### Gzip if not gzipped
echo GZIP IF NOT DONE
cd ./00_sra
for f in ${SAMPLE}_${SRA}*.*
  do
   if (file $f | grep -q compressed ) ; then
     echo "Yes, your file "${f}" is compressed"
   else gzip $f
   fi
  done
cd ..

### Check if paired
echo CHECK PAIRED AND SINGLE
python 00_check_paired.py ${SAMPLE}_${SRA}

### Check lengths and encoding
echo CHECK LENGTHS & ENCODING
conda activate seqkit
cd ./00_sra
for FQ in ${SAMPLE}_${SRA}*.gz
  do
  FQ_NAME=$(echo $FQ | sed 's/.fastq.gz//g' | sed 's/.fq.gz//g')
  echo ${FQ_NAME}
  # Get read lengths
  seqkit stats ${FQ} -o "stats_"${FQ_NAME}".txt"
  # Check encoding
  sh ../00_check_encoding.sh ${FQ} > "encoding_"${FQ_NAME}".txt"
  done
cd ..
conda deactivate

### Create config for each sample pair or SE
echo CREATE CONFIGS
conda activate mbio
python 00_get_configs.py ${SAMPLE} ${SRA} ./00_sra
conda deactivate
