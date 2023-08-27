#!/bin/bash


. ${1}
multiqc -f -p -o output2_${SAMPLE} ./output2_${SAMPLE}
