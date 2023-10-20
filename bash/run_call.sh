#!/bin/bash

### Inputs
SRA=${1}
SAMP=${2}

### Read config
CONFIG=`pwd`/config_${SAMP}_${SRA}_PE.txt
. ${CONFIG}


### Bcftools for diploids
echo "BCFTOOLS"
mkdir -p 08_bcftools
source activate bcftools
sh 08_01_bcftools.sh ${CONFIG}
conda deactivate
