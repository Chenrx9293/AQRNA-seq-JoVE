import time
filename='_4_trimmedCount'
def formattrimmedcount(filename):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()

    fileline=['filename']
    line=['number of sequences >10 bp after trimming NN']

    row=0
    while row<len(fin):
        fin[row]=fin[row].rstrip('\n')
        cut=fin[row].split(' ')
        cut[0]=int(cut[0])/2
        cut[0]=str(cut[0])
        line.append(cut[0])
        fileline.append(cut[1].replace('fastq/*/201215Ded_',''))
        row=row+1

    return [fileline,line]
    totaltime = time.time() - start_time
    print 'formattrimmedcount took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

output=formattrimmedcount(filename)

fileline='\t'.join(output[0])
writelines=[fileline]
countline='\t'.join(output[1])
writelines.append(countline)
with open(filename+'_formatted.txt', 'w') as fo:
    fo.write('\n'.join(writelines))

print filename+'_formatted.txt was written'
