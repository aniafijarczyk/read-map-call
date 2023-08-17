import glob
import sys

# Data
sample = sys.argv[1]
path = sys.argv[2]
fastqc = glob.glob(path + "/fastqc_" + sample + "*_fastqc.txt")
multiqc = path + "/multiqc_fastqc_" + sample + ".txt"

# Read fastqc output
QC = {}
for fqc in fastqc:
  fh = open(fqc, "r")
  linie = fh.readlines()
  k = [ele.split() for ele in linie]
  d = {a[0].replace("_fastqc","") : a[1:] for a in k}
  QC.update(d)

# Read multiqc output
fh = open(multiqc, "r")
linie = fh.readlines()
k = [ele.split("\t") for ele in linie]

# Check of read length
mqc = k[1:]
mqc_info = []
for row in mqc:
  row_format = [ele.replace(" " ,"").replace("\n","") for ele in row]
  rl = row_format[7].split("-")
  if len(rl) > 1:
    info = "span"
  elif len(rl) == 1:
    info = "single"
  nrow = [sample] + row_format + [info]
  mqc_info.append(nrow)
#print(mqc_info)

# Merging tables and writing output
wh = open("multiqc_fastqc_combine.out", "w")
for row in mqc_info:
  nrow = row + QC[row[1]]
  wh.write("\t".join(nrow) + "\n")
wh.flush()
wh.close()
