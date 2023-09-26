import time
import sys
try:
    filename = sys.argv[1]
except:
    print(__doc__)
    sys.exit(1)

def formatlinkercount(filename):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()

    fileline=['']
    line=[['sequences containing '+fin[1].rstrip('\n').split('\\t')[0]],
    ['sequences containing --'+fin[2].rstrip('\n').split('\\t')[0]],
    ['sequences containing '+fin[3].rstrip('\n').split('\\t')[0]+'--'],
    ['sequences containing '+fin[4].rstrip('\n').split('\\t')[0]],
    ['sequences containing --'+fin[5].rstrip('\n').split('\\t')[0]],
    ['sequences containing '+fin[6].rstrip('\n').split('\\t')[0]+'--'],
    ['sequences containing '+fin[7].rstrip('\n').split('\\t')[0]],
    ['sequences containing --'+fin[8].rstrip('\n').split('\\t')[0]],
    ['sequences containing '+fin[9].rstrip('\n').split('\\t')[0]+'--'],
    ['sequences containing '+fin[10].rstrip('\n').split('\\t')[0]],
    ['sequences containing --'+fin[11].rstrip('\n').split('\\t')[0]],
    ['sequences containing '+fin[12].rstrip('\n').split('\\t')[0]+'--']]

    row=0
    while row<len(fin):
        fin[row]=fin[row].rstrip('\n')
        if row%13==0:
            cut=fin[row].split('/')
            cut=cut[2].split('_')
            filen="_".join(cut[0:3])
            fileline.append(filen)
        else:
            count=fin[row].split('\\t')[1]
            line[row%13-1].append(count)
        row=row+1

    return [fileline,line]
    totaltime = time.time() - start_time
    print 'formatlinkercount took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

output=formatlinkercount(filename)

fileline='\t'.join(output[0])
writelines=[fileline]
for item in output[1]:
    countline='\t'.join(item)
    writelines.append(countline)
    with open(filename+'_formatted.txt', 'w') as fo:
        fo.write('\n'.join(writelines))

print filename+'_formatted.txt was written'
