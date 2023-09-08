# bash

Scripts for running the pipeline using bash, python scripts and conda environments. Kind of simplistic but works.

Basic execution for a single SRA ID:

```
source run.sh <SRA ID> <SAMPLE NAME>
```


The script:
- downloads reads from SRA given SRR ID
- gzips fastq if needed
- checks if they are paired or single
- checks fastq phred encoding
- checks the mean read length
- writes config file for each paired/single read file (required for the next step)
- checks quality of reads with fastqc and multiqc
- trimms reads
- checks quality again
- maps reads to given fasta reference
- sorts and realigns the reads
- checks mean read depth
- marks duplicates
- checks read depth again, including across chromosomes/contigs
- runs bcftools to call variants in diploid state (useful for checking ploidy)


The runner script *run.sh* launches two scripts: *run_download.sh* which downloads fastq from ncbi,  
and *run_download.sh* which maps the reads to the reference.  
To run run.sh first modify config information in the *00_06_get_config.py* file. At least give the path to the reference file.  
The script *run_make_commands.sh* with generate single-line commands for all SRA in the list.  
The script *run_slurm.sh* shows an example how to launch it using slurm.  
