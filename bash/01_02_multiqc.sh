#!/bin/bash


. ${1}
multiqc -f -p -o output_${SAMPLE} ./output_${SAMPLE}
