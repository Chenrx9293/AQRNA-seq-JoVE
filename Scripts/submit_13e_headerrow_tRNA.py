line=['Full length RNA count -- eVal culled']
files=['RNA_ID','D22-12879']
line.append('\t'.join(files))
a='\n'.join(line)
a=a+'\n'
with open('tRNA_counts/FLcount_bytRNA_eValculled.txt', 'w') as fo:
    fo.write(a)

line=['Complete RNA count -- eVal culled']
files=['tRNA','D22-12879']
line.append('\t'.join(files))
a='\n'.join(line)
a=a+'\n'
with open('tRNA_counts/ALLcount_bytRNA_eValculled.txt', 'w') as fo:
    fo.write(a)