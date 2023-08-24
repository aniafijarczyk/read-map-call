#!/bin/bash


### Read config
#. `pwd`/config_SAMPLE_SRA_PE.txt
. `pwd`/${1}

### Temporary directory
mkdir -p output_${SAMPLE}

### Fastqc
echo QUALITY CHECK
mkdir -p 01_fastqc
mkdir -p 01_fastqc_zip
fq=$(ls $PE1 $PE2 $SE)
conda activate gapp
fastqc $fq -o output_${SAMPLE} -t ${FASTQC_THREADS}
conda deactivate

### Multiqc
conda activate multiqc
multiqc -f -p -o output_${SAMPLE} ./output_${SAMPLE}
conda deactivate

### Outputs

conda activate mbio
cd output_${SAMPLE}
for zip in *.zip
  do
  unzip -u $zip
  core=$(echo $zip | sed 's/.zip//g')
  cp ${core}/Images/per_base_quality.png ../01_fastqc/fastqc_per_base_quality_${core}.png
  cp ${core}/Images/per_tile_quality.png ../01_fastqc/fastqc_per_tile_quality_${core}.png
  python ../01_fastqc_01_qc.py ${core}/fastqc_data.txt
  cp fastqc_${core}.txt ../01_fastqc/
  cp ${zip} ../01_fastqc_zip/
  done
cp ./multiqc_data/multiqc_fastqc.txt ../01_fastqc/multiqc_fastqc_${SAMPLE}.txt
python ../01_fastqc_02_combine.py ${SAMPLE} ../01_fastqc
cp multiqc_fastqc_combine.out ../01_fastqc/multiqc_fastqc_combine_${SAMPLE}.out
cd ..
conda deactivate
rm -r output_${SAMPLE}

### Trimming
echo TRIMMING
mkdir -p 02_trimmed
conda activate trimmomatic-0.39
trimmomatic PE -threads ${TRIMMOMATIC_THREADS} -phred${PHRED} $PE1 $PE2 \
02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R1U.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz 02_trimmed/${SAMPLE}_R2U.fastq.gz \
ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:${MINLEN}
rm 02_trimmed/${SAMPLE}_R1U.fastq.gz
rm 02_trimmed/${SAMPLE}_R2U.fastq.gz
conda deactivate

### Fastqc
echo QUALITY CHECK 2
mkdir -p output2_${SAMPLE}
mkdir -p 03_fastqc
mkdir -p 03_fastqc_zip
fq=$(ls 02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz)
conda activate gapp
fastqc $fq -o output2_${SAMPLE} -t ${FASTQC_THREADS}
conda deactivate

### Multiqc
conda activate multiqc
multiqc -f -p -o output2_${SAMPLE} ./output2_${SAMPLE}
conda deactivate

conda activate mbio
cd output2_${SAMPLE}
for zip in *.zip
  do
  unzip -u $zip
  core=$(echo $zip | sed 's/.zip//g')
  cp ${core}/Images/per_base_quality.png ../03_fastqc/fastqc_per_base_quality_${core}.png
  cp ${core}/Images/per_tile_quality.png ../03_fastqc/fastqc_per_tile_quality_${core}.png
  python ../01_fastqc_01_qc.py ${core}/fastqc_data.txt
  cp fastqc_${core}.txt ../03_fastqc/
  cp ${zip} ../03_fastqc_zip/
  done
cp ./multiqc_data/multiqc_fastqc.txt ../03_fastqc/multiqc_fastqc_${SAMPLE}.txt
python ../01_fastqc_02_combine.py ${SAMPLE} ../03_fastqc
cp multiqc_fastqc_combine.out ../03_fastqc/multiqc_fastqc_combine_${SAMPLE}.out
cd ..
conda deactivate
rm -r output2_${SAMPLE}


### Mapping
echo MAPPING
mkdir -p 04_bwa
conda activate samtools
###if [ $PE1 ];
###then

samtools faidx $REF
bwa index $REF
bwa mem -t $BWA_THREADS -R "@RG\tID:"${PE_FLOWCELL_LANE}"."${PE_LANE_NUMBER}"\tLB:"${SAMPLE}"\tPL:"${PLATFORM}"\tPU:"${PE_FLOWCELL_LANE}"."${SAMPLE}"\tSM:"${SAMPLE}"" \
$REF 02_trimmed/${SAMPLE}_R1P.fastq.gz 02_trimmed/${SAMPLE}_R2P.fastq.gz | samtools sort -@ $SAMTOOLS_THREADS -u - | samtools calmd -bAQr -@ $SAMTOOLS_THREADS - ${REF} > 04_bwa/${SAMPLE}_sorted.bam
samtools index 04_bwa/${SAMPLE}_sorted.bam
samtools stats 04_bwa/${SAMPLE}_sorted.bam > 04_bwa/${SAMPLE}_sorted.stat

###if [ $SE ];
###then echo "SE"
###fi
# Check if multiple files per sample, if yes merge them
conda deactivate


### Read depth
echo READ DEPTH
mkdir -p 05_depth
conda activate mosdepth
mosdepth --fast-mode --by 1000 ./05_depth/${SAMPLE} ./04_bwa/${SAMPLE}_sorted.bam
conda deactivate


cd 05_depth
gzip -d ${SAMPLE}.per-base.bed.gz
sh ../05_check_depth.sh ${SAMPLE}.per-base.bed
gzip -f ${SAMPLE}.per-base.bed
rm ${SAMPLE}.mosdepth.*.dist.txt
rm ${SAMPLE}.per-base.bed*
rm ${SAMPLE}.regions.bed*
cd ..


# Plot coverage


### Mark duplicates
echo MARKING DUPLICATES
mkdir -p 06_rmdup
conda activate picard
picard MarkDuplicates I=./04_bwa/${SAMPLE}_sorted.bam O=./06_rmdup/${SAMPLE}_rmdup.bam M=./06_rmdup/${SAMPLE}_picard.metrics REMOVE_DUPLICATES=true
conda deactivate
# Indexing
conda activate samtools
samtools index 06_rmdup/${SAMPLE}_rmdup.bam
conda deactivate

### Read depth using mosdepth (good reads only)
echo READ DEPTH 2

mkdir -p 07_depth
conda activate mosdepth
mosdepth --fast-mode --by 1000 ./07_depth/${SAMPLE} ./06_rmdup/${SAMPLE}_rmdup.bam
conda deactivate
cd 07_depth
gzip -d ${SAMPLE}.per-base.bed.gz
sh ../07_check_depth.sh ${SAMPLE}.per-base.bed
gzip -f ${SAMPLE}.per-base.bed
rm ${SAMPLE}.mosdepth.*.dist.txt
rm ${SAMPLE}.per-base.bed*
cd ..



### Bcftools for diploids
echo BCFTOOLS
mkdir -p 08_bcftools
conda activate bcftools
bcftools mpileup -C50 -f ${REF} -q4 -a FORMAT/AD,FORMAT/ADR,FORMAT/ADF,FORMAT/DP -Ou ./06_rmdup/${SAMPLE}_rmdup.bam | \
bcftools call -mv -f gq -Oz -o ./08_bcftools/${SAMPLE}_bcftools.vcf.gz -
tabix -p vcf ./08_bcftools/${SAMPLE}_bcftools.vcf.gz
conda deactivate

### Remove big files
rm ./02_trimmed/${SAMPLE}_R?P.fastq.gz
rm ./04_bwa/${SAMPLE}_sorted.bam


### Check allele frequencies
### Check ploidy
### Find CNVs
