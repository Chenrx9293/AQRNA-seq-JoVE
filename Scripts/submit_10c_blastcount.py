import time
filename='_5_tRNAblastcount'
def formatblastcount(filename):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()

    fileline=['filename']
    line=['number of sequences aligned after blast']

    row=0
    while row<len(fin):
        fin[row]=fin[row].rstrip('\n')
        cut=fin[row].split('\t')
        line.append(cut[0])
        fileline.append(cut[1])
        row=row+1

    return [fileline,line]
    totaltime = time.time() - start_time
    print 'formatblastcount took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

output=formatblastcount(filename)

fileline='\t'.join(output[0])
writelines=[fileline]
countline='\t'.join(output[1])
writelines.append(countline)
with open(filename+'_formatted.txt', 'w') as fo:
    fo.write('\n'.join(writelines))

print filename+'_formatted.txt was written'
