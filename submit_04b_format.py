import time
import sys
try:
    filename = sys.argv[1]
except:
    print(__doc__)
    sys.exit(1)

def formatcount(filename):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()
    row=0
    fileline=['file']
    seqcount=['number of reads after 3 prime clipping']
    while row<len(fin):
        fin[row+1]=fin[row+1].rstrip('\n')
        line=fin[row+1].split('\\t')
        cut=line[1].split('/')[2].split('_')
        filen='_'.join(cut[0:3])
        fileline.append(filen)
        seqcount.append(line[0])
        row=row+3
    return [fileline,seqcount]
    totaltime = time.time() - start_time
    print 'formatcount took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

output=formatcount(filename)

fileline='\t'.join(output[0])
seqline='\t'.join(output[1])

with open(filename+'_formatted.txt', 'w') as fo:
    fo.write('\n'.join([fileline,seqline]))

print filename+'_formatted.txt was written'
