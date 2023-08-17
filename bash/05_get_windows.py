import pandas as pd
import numpy as np
import glob as glob
import sys

depth_file = sys.argv[1]
start=1
by=1000
win=1000

df = pd.read_csv(depth_file, sep = '\t', header = None, names = ['chrom','pos','cov'])
sampleID = depth_file.split('/')[-1].replace(".out","")
sample = sampleID.replace("_sorted_depth","")
dgroup = df.groupby(['chrom']).rolling(window=win,on='pos',center=True).mean()[start::by].reset_index().rename(columns={'level_1':'index'})
dgroup['sampleID'] = sample
dgroup.to_csv(sampleID+'_windows.out')
