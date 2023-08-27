#!/bin/bash


samples=sra_list_Candida_glabrata.txt

rm run_commands.txt
touch run_commands.txt
while read sample
  do
  SAMPLE=$(echo $sample | cut -d" " -f1)
  SRA=$(echo $sample | cut -d" " -f2)
  #echo $SAMPLE
  echo "source run.sh ${SRA} ${SAMPLE}" >> run_commands.txt
  done<${samples}
