# read-map-call
General workflow for downloading, processing and mapping reads.



Steps of the workflow:

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

