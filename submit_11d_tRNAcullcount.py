import time

def formatcullcount(filename,i):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()

    fileline=['filename']
    coltitle=['number of dupe(discarded) reads','number of non-dupe reads','total number of culled reads']
    line=[coltitle[i]]

    row=0
    while row<len(fin):
        fin[row]=fin[row].rstrip('\n')
        cut=fin[row].split('\t')
        line.append(cut[0])
        fileline.append(cut[1])
        row=row+1

    return [fileline,line]
    totaltime = time.time() - start_time
    print 'formatcullcount took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

i=0
filename=['_7_tRNA_culled_disc_count','_7_tRNA_culled_nodupe_count','_7_tRNA_culled_all_count']
while i<len(filename):
    output=formatcullcount(filename[i],i)
    fileline='\t'.join(output[0])
    writelines=[fileline]
    countline='\t'.join(output[1])
    writelines.append(countline)
    with open(filename[i]+'_formatted.txt', 'w') as fo:
        fo.write('\n'.join(writelines))

    print filename[i]+'_formatted.txt was written'
    i=i+1
