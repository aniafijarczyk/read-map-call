#!/bin/bash

### Inputs
SRA=${1}
SAMP=${2}


### Read config
CONFIG=`pwd`/config_${SAMP}_${SRA}.txt
. ${CONFIG}

### Temporary directory
mkdir -p output_${SAMPLE}

### Fastqc
echo "QUALITY CHECK"
mkdir -p 01_fastqc
mkdir -p 01_fastqc_zip
source activate fastqc
sh 01_01_fastqc.sh ${CONFIG}
conda deactivate

### Multiqc
source activate multiqc
sh 01_02_multiqc.sh ${CONFIG}
conda deactivate

### Outputs
source activate mbio
cd output_${SAMPLE}
sh ../01_03_combine.sh ${SAMPLE}
cd ..
conda deactivate
rm -r output_${SAMPLE}

### Trimming
echo "TRIMMING"
mkdir -p 02_trimmed
source activate trimmomatic
sh 02_01_trim.sh ${CONFIG}
conda deactivate
rm 02_trimmed/${SAMPLE}_R1U.fastq.gz
rm 02_trimmed/${SAMPLE}_R2U.fastq.gz

### Fastqc
echo "QUALITY CHECK 2"
mkdir -p output2_${SAMPLE}
mkdir -p 03_fastqc
mkdir -p 03_fastqc_zip
source activate fastqc
sh 03_01_fastqc.sh ${CONFIG}
conda deactivate

### Multiqc
source activate multiqc
sh 03_02_multiqc.sh ${CONFIG}
conda deactivate

### Outputs
source activate mbio
cd output2_${SAMPLE}
sh ../03_03_combine.sh ${SAMPLE}
cd ..
conda deactivate
rm -r output2_${SAMPLE}

### Mapping
echo "MAPPING"
mkdir -p 04_bwa
source activate samtools
sh 04_01_bwa.sh ${CONFIG} ${SAMP}
conda deactivate

### Read depth
echo "READ DEPTH"
mkdir -p 05_depth
source activate mosdepth
sh 05_01_mosdepth.sh ${SAMPLE}
conda deactivate

cd 05_depth
sh ../05_02_get_depth.sh ${SAMPLE}
cd ..

### Mark duplicates
echo "MARKING DUPLICATES"
mkdir -p 06_rmdup
source activate picard
sh 06_01_picard.sh ${SAMPLE}
conda deactivate

# Indexing
source activate samtools
sh 06_02_index_bam.sh ${SAMPLE}
conda deactivate

### Read depth using mosdepth (good reads only)
echo "READ DEPTH 2"
mkdir -p 07_depth
source activate mosdepth
sh 07_01_mosdepth.sh ${SAMPLE}
conda deactivate

cd 07_depth
sh ../07_02_get_depth.sh ${SAMPLE}
cd ..

### Bcftools for diploids
echo "BCFTOOLS"
mkdir -p 08_bcftools
source activate bcftools
sh 08_01_bcftools.sh ${CONFIG}
conda deactivate

### Removing big files
rm ./02_trimmed/${SAMPLE}_R?P.fastq.gz
rm ./02_trimmed/${SAMPLE}_SE.fastq.gz
rm ./04_bwa/${SAMPLE}_sorted.bam
rm ./00_sra/${SAMPLE}_1.fastq.gz
rm ./00_sra/${SAMPLE}_2.fastq.gz
rm ./00_sra/${SAMPLE}.fastq.gz
