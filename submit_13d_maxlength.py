import sys
try:
    tRNA = sys.argv[1]
    fasta = sys.argv[2]
except:
    print(__doc__)
    sys.exit(1)

def getFastaLengths(fasta):
    fin=open(fasta, 'rU').readlines()
    fastadict={}
    row=0
    while row<len(fin):
        if fin[row][0]=='>':
            fin[row]=fin[row].rstrip('\n')
            fin[row]=fin[row].split(' ')[0]
            fin[row]=fin[row][1:]
            fin[row+1]=fin[row+1].rstrip('\n')
            fastadict[fin[row]]=len(fin[row+1])
        row=row+2
    return fastadict

refList=getFastaLengths(fasta)

print refList[tRNA]
