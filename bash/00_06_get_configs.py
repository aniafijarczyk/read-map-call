import pandas as pd
import numpy as np
import glob
import re
import sys

# Input variables
#SAMPLE = "CALB0456"
SAMPLE = sys.argv[1]
#SRA = "SRR392813"
SRA = sys.argv[2]
#FASTQ_PATH = "./00_sra"
FASTQ_PATH = sys.argv[3]

# Global variables
PATH_REFERENCE = "/home/DATA/Candida_glabrata_reference/C_glabrata_CBS138_version_s05-m03-r02_chromosomes.fasta"
FASTQ_THREADS = 2
TRIMMOMATIC_THREADS = 2
FASTQ_PHRED = 33
READ_MIN_LENGTH = 31
PE_FLOWCELL_LANE = SRA
PE_FLOWCELL_NUMBER = SRA
PLATFORM = "ILLUMINA"
BWA_THREADS = 2
SAMTOOLS_THREADS = 2
PLOIDY = 1


def pairingFile():
    dP = pd.read_csv(FASTQ_PATH + "/pairing_" + SAMPLE + "_" + SRA + ".txt", sep = "\t", header=None, names = ['path', 'label'])
    dP['file'] = dP['path'].apply(lambda x: x.split('/')[-1])
    return(dP)

def statsFiles():
    stats = glob.glob(FASTQ_PATH + "/stats_" + SAMPLE + "_" + SRA + "*.txt")
    S = []
    for stat in stats:
        ds_ = pd.read_csv(stat, sep = '\s+', header=0, thousands=',')
        S.append(ds_)   
    dS = pd.concat(S, ignore_index=True)
    return(dS)

def encodingFiles():
    encodings = glob.glob(FASTQ_PATH + "/encoding_" + SAMPLE + "_" + SRA + "*.txt")
    E = []
    for enc in encodings:
        de_ = pd.read_csv(enc, sep = ' ', header=None, names = ['file','encoding'])
        E.append(de_)
    dE = pd.concat(E, ignore_index=True)
    return(dE)


def writeConfig(dataframe):

    # Defining sets
    sets = dataframe['set'].drop_duplicates().values.tolist()
    for dset in sets:
    
        print(dset)
        # Getting files 
        df_ = dataframe[dataframe['set'] == dset].reset_index(drop=True)
    
        # Setting other variables
        sample_id = SAMPLE + "_" + SRA
        FASTQ_PHRED = df_['encoding'].head(1).values[0]
        avg_length = df_['avg_len'].head(1).values[0].astype(int)
        if avg_length <= 40:
            READ_MIN_LENGTH = 10
        else:
            READ_MIN_LENGTH = 31  
    
        if dset == 'PE':
            path_PE1 = df_.loc[df_['label'] == 'PE1', 'path'].values[0]
            path_PE2 = df_.loc[df_['label'] == 'PE2', 'path'].values[0]
    
            config_PE = """
### Sample
SAMPLE=""" + sample_id + """
### Input files
TYPE=PE
PE1=""" + path_PE1 + """
PE2=""" + path_PE2 + """
### FASTQC
#Each thread will be allocated 250MB of memory so you  shouldn't  run  more  threads  than  your
#available memory will cope with, and not more than 6 threads on a 32 bit machine
FASTQC_THREADS=""" + str(FASTQ_THREADS) + """
### Adapters
ADAPTERS=trimmomatic_adapters_PE.fa
TRIMMOMATIC_THREADS=""" + str(TRIMMOMATIC_THREADS) + """
PHRED=""" + str(FASTQ_PHRED) + """
MINLEN=""" + str(READ_MIN_LENGTH) + """
### Flowcell lane
PE_FLOWCELL_LANE=""" + PE_FLOWCELL_LANE + """
PE_LANE_NUMBER=""" + PE_FLOWCELL_NUMBER + """
### bwa
PLATFORM=""" + PLATFORM + """
BWA_THREADS=""" + str(BWA_THREADS) + """
SAMTOOLS_THREADS=""" + str(SAMTOOLS_THREADS) + """
REF=""" + PATH_REFERENCE + """
PLOIDY=""" + str(PLOIDY) + """
"""

            wh = open('config_' + sample_id + '.txt', 'w')
            wh.write(config_PE)
            wh.flush()
            wh.close()
    
        elif dset == 'SE':
            path_SE = df_.loc[df_['label'] == 'SE', 'path'].values[0]
    
            config_SE = """
### Sample
SAMPLE=""" + sample_id + """
### Input files
TYPE=SE
SE=""" + path_SE + """
### FASTQC
#Each thread will be allocated 250MB of memory so you  shouldn't  run  more  threads  than  your
#available memory will cope with, and not more than 6 threads on a 32 bit machine
FASTQC_THREADS=""" + str(FASTQ_THREADS) + """
### Adapters
ADAPTERS=trimmomatic_adapters_SE.fa
TRIMMOMATIC_THREADS=""" + str(TRIMMOMATIC_THREADS) + """
PHRED=""" + str(FASTQ_PHRED) + """
MINLEN=""" + str(READ_MIN_LENGTH) + """
### Flowcell lane
PE_FLOWCELL_LANE=""" + PE_FLOWCELL_LANE + """
PE_LANE_NUMBER=""" + PE_FLOWCELL_NUMBER + """
### bwa
PLATFORM=""" + PLATFORM + """
BWA_THREADS=""" + str(BWA_THREADS) + """
SAMTOOLS_THREADS=""" + str(SAMTOOLS_THREADS) + """
REF=""" + PATH_REFERENCE + """
PLOIDY=""" + str(PLOIDY) + """
"""

            wh = open('config_' + sample_id + '.txt', 'w')
            wh.write(config_SE)
            wh.flush()
            wh.close()

    


if __name__ == '__main__':

    # Reading file with paired or single label
    dP = pairingFile()

    # Reading files with read statistics
    dS = statsFiles()

    # Reading files with read encodings
    dE = encodingFiles()
    
    # Merging files
    dM = pd.merge(dS, dP, on = 'file', how = 'left')
    dM = pd.merge(dM, dE, on = 'file', how = 'left')

    # Sorting each file to a set
    dM['set'] = dM['label'].apply(lambda x: 'PE' if x.startswith('PE') else 'SE')

    # Writing each set to a config file
    writeConfig(dM)
    




    
    
