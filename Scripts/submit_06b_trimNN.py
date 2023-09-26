import time
import sys
try:
    filename = sys.argv[1]
except:
    print(__doc__)
    sys.exit(1)

def trimNN(filename):
    start_time = time.time()
    fin=open(filename, 'rU').readlines()
    row=0
    writelines=[]
    while row<len(fin):
        fin[row]=fin[row].rstrip('\n')
        length=len(fin[row])
        if row%4==0:
            writelines.append(fin[row])
        if row%4==1:
            if length<74:
                writelines.append(fin[row][0:length-2])
            elif length==74:
                writelines.append(fin[row][0:length-1])
            else:
                writelines.append(fin[row])
        if row%4==2:
            writelines.append(fin[row])

        if row%4==3:
            if length<74:
                writelines.append(fin[row][0:length-2])
            elif length==74:
                writelines.append(fin[row][0:length-1])
            else:
                writelines.append(fin[row])
        row=row+1
    return writelines
    totaltime = time.time() - start_time
    print 'trimNN took', totaltime, 'seconds or', totaltime/float(60),'minutes to run'

output=trimNN(filename)

with open(filename+'_trimNN', 'w') as fo:
    fo.write('\n'.join(output))

print filename+'_trimNN was written'
