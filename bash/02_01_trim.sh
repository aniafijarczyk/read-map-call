#!/bin/bash

. ${1}
trimmomatic PE -threads ${TRIMMOMATIC_THREADS} -phred${PHRED} $PE1 $PE2 \
02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R1U.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz 02_trimmed/${SAMPLE}_R2U.fastq.gz \
ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:${MINLEN}
