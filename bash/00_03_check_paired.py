import glob
import re
import sys

#sample = "CALB0456"
#srr = "SRR392813"

sample = sys.argv[1]
#srr = sys.argv[2]




def findPattern(filename):
    
    # Looking for pattern "_1"
    pattern_left = re.compile(r".*_1.*")
    pattern_right = re.compile(r".*_2.*")

    if pattern_left.match(filename):
        print("%s\tPE1" %filename)
        p = "%s\tPE1" %filename
    elif pattern_right.match(filename):
        print("%s\tPE2" %filename)
        p = "%s\tPE2" %filename
    else:
        print("%s\tSE" %filename)
        p = "%s\tSE" %filename
    return(p)



if __name__ == '__main__':
    
    # Getting all sample files
    fnames = glob.glob("./00_sra/" + sample + "*.gz")
    
    # For each file find the description
    P = []
    for fname in fnames:
        p = findPattern(fname)
        P.append(p)
        
    # Saving output
    wh = open("./00_sra/pairing_"+sample+".txt", "w")
    for f in P:
        wh.write(f + "\n")
    wh.flush()
    wh.close()
