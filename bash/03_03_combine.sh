#!/bin/bash

SAMPLEID=${1}

for zip in *.zip
  do
  unzip -u $zip
  core=$(echo $zip | sed 's/.zip//g')
  cp ${core}/Images/per_base_quality.png ../03_fastqc/fastqc_per_base_quality_${core}.png
  cp ${core}/Images/per_tile_quality.png ../03_fastqc/fastqc_per_tile_quality_${core}.png
  python ../01_04_fastqc_combine.py ${core}/fastqc_data.txt
  cp fastqc_${core}.txt ../03_fastqc/
  cp ${zip} ../03_fastqc_zip/
  done
cp ./multiqc_data/multiqc_fastqc.txt ../03_fastqc/multiqc_fastqc_${SAMPLEID}.txt
python ../01_05_fastqc_combine.py ${SAMPLEID} ../03_fastqc
cp multiqc_fastqc_combine.out ../03_fastqc/multiqc_fastqc_combine_${SAMPLEID}.out

