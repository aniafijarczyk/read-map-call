import glob
import sys
import pandas as pd


# Data
sample = sys.argv[1]
path = sys.argv[2]
fastqc = glob.glob(path + "/fastqc_" + sample + "*_fastqc.txt")
multiqc = path + "/multiqc_fastqc_" + sample + ".txt"



def readFastqc(filenames):

    # Read fastqc output
    QC = {}
    for fqc in filenames:
      fh = open(fqc, "r")
      linie = fh.readlines()
      k = [ele.split() for ele in linie]
      d = {a[0].replace("_fastqc","") : a[1:] for a in k}
      QC.update(d)

    fq = pd.DataFrame(QC).T.reset_index()
    old_names = fq.columns
    new_names = ['Sample', 'quality_start','quality_middle','quality_end']
    fq = fq.rename(columns = {a:b for a,b in zip(old_names, new_names)})
    return(fq)


def readMultiqc(filename):
    df = pd.read_csv(filename, sep='\t', header=0)
    return(df)




if __name__ == '__main__':
    
    df_fastqc = readFastqc(fastqc)
    df_multiqc = readMultiqc(multiqc)
    df_combined = pd.merge(df_fastqc, df_multiqc, on = 'Sample', how = 'left')

    df_combined.to_csv("multiqc_fastqc_combine.out", sep='\t', header=True, index=False)