# read-map-call
General workflow for downloading, processing and mapping reads.

# bash

Scripts for running the pipeline using bash, python scripts and conda environments. Kind of simplistic but works.

Basic execution for a single SRA ID:

```
source run_all.sh
```

This executes two main scripts:
1) run_download.sh:
- downloads reads from SRA given SRR ID
- gzips fastq if needed
- checks if they are paired or single
- checks fastq phred encoding
- checks the mean read length
- writes config file for each paired/single read file (required for the next step)

2) run_map.sh:
- checks quality of reads with fastqc and multiqc
- trimms reads
- checks quality again
- maps reads to given fasta reference
- sorts and realigned the reads
- checks mean read depth
- marks duplicates
- checks read depth again, including across chromosomes/contigs
- runs bcftools to call variants in diploid state (useful for checking ploidy)

```
SRA=SRR392813
SAMPLE=CALB0456

# Download fastq
source run_download.sh $SRA $SAMPLE

# Run mapping
source run_map.sh config_${SAMPLE}_${SRA}_PE.txt
```
