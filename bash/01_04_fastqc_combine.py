import sys
import glob

fname = sys.argv[1]

# Read qc table
fh = open(fname, "r")
linie = fh.readlines()
k = [ele.split() for ele in linie]
end = 0
qc = []
for ele in k:
  if ele == [">>END_MODULE"]:
    end+=1
  if end == 1:
    qc.append(ele)

# Extract qualities
qc_means = [float(i[1]) for i in qc[3:]]
qc_n = len(qc_means)
qc_med = int(qc_n/2)

# write to file
sample = fname.split("/")[-2]
wh = open("fastqc_"+sample+".txt","w")
wh.write(sample + "\t" + str(qc_means[0]) + "\t" + str(qc_means[qc_med]) + "\t" + str(qc_means[-1]) + "\n")
wh.flush()
wh.close()
