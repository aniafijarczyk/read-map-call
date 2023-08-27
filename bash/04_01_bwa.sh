#!/bin/bash

. ${1}
SAMPLE_NAME=${2}

samtools faidx $REF
bwa-mem2 index $REF
bwa-mem2 mem -t $BWA_THREADS -R "@RG\tID:"${PE_FLOWCELL_LANE}"."${PE_LANE_NUMBER}"\tLB:"${SAMPLE_NAME}"\tPL:"${PLATFORM}"\tPU:"${PE_FLOWCELL_LANE}"."${SAMPLE_NAME}"\tSM:"${SAMPLE_NAME}"" \
$REF 02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz | samtools sort -@ $SAMTOOLS_THREADS -u - | samtools calmd -bAQr -@ $SAMTOOLS_THREADS - ${REF} > 04_bwa/${SAMPLE}_sorted.bam
samtools index 04_bwa/${SAMPLE}_sorted.bam
samtools stats 04_bwa/${SAMPLE}_sorted.bam > 04_bwa/${SAMPLE}_sorted.stat
