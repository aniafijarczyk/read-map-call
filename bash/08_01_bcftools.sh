#!/bin/bash

. ${1}

if [ -f "./06_rmdup/${SAMPLE}_rmdup.bam" ]; then


  if [ $PLOIDY = "1" ] ; then
  echo "Ploidy is 1"
  bcftools mpileup -C50 -f ${REF} -min-MQ 4 -min-BQ 13 --skip-any-set 1796 -a FORMAT/AD,FORMAT/ADR,FORMAT/ADF,FORMAT/DP -Ou -b ./06_rmdup/${SAMPLE}_rmdup.bam | \
  bcftools call -m -f gq -ploidy 1 -Oz -o ./08_bcftools/${SAMPLE}_bcftools.vcf.gz -
  tabix -f -p vcf ./08_bcftools/${SAMPLE}_bcftools.vcf.gz

  elif [ $PLOIDY = "2" ] ; then
  echo "Ploidy is 2"
  bcftools mpileup -C50 -f ${REF} -min-MQ 4 -min-BQ 13 --skip-any-set 1796 -a FORMAT/AD,FORMAT/ADR,FORMAT/ADF,FORMAT/DP -Ou -b ./06_rmdup/${SAMPLE}_rmdup.bam | \
  bcftools call -m -f gq -Oz -o ./08_bcftools/${SAMPLE}_bcftools.vcf.gz -
  tabix -f -p vcf ./08_bcftools/${SAMPLE}_bcftools.vcf.gz

  else
  echo "Ploidy is more than 2 and is set to 2"
  bcftools mpileup -C50 -f ${REF} -min-MQ 4 -min-BQ 13 --skip-any-set 1796 -a FORMAT/AD,FORMAT/ADR,FORMAT/ADF,FORMAT/DP -Ou -b ./06_rmdup/${SAMPLE}_rmdup.bam | \
  bcftools call -m -f gq -Oz -o ./08_bcftools/${SAMPLE}_bcftools.vcf.gz -
  tabix -f -p vcf ./08_bcftools/${SAMPLE}_bcftools.vcf.gz
  fi


fi
