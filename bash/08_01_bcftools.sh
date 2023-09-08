#!/bin/bash

. ${1}

if [ -f "./06_rmdup/${SAMPLE}_rmdup.bam" ]; then

bcftools mpileup -C50 -f ${REF} -q4 -a FORMAT/AD,FORMAT/ADR,FORMAT/ADF,FORMAT/DP -Ou ./06_rmdup/${SAMPLE}_rmdup.bam | \
bcftools call -mv -f gq -Oz -o ./08_bcftools/${SAMPLE}_bcftools.vcf.gz -
tabix -p vcf ./08_bcftools/${SAMPLE}_bcftools.vcf.gz

fi
