line=['Full length RNA count -- eVal culled']
files=['tRNA','D18-6947', 'D18-6948', 'D18-6949', 'D18-6950', 'D18-6951', 'D18-6952', 'D18-6953', 'D18-6954', 'D18-6955', 'D18-6956', 'D18-6957', 'D18-6958', 'D18-6959', 'D18-6960', 'D18-6961']
line.append('\t'.join(files))
a='\n'.join(line)
a=a+'\n'
with open('tRNA_counts/FLcount_bytRNA_eValculled.txt', 'w') as fo:
    fo.write(a)

line=['Complete RNA count -- eVal culled']
files=['tRNA','D18-6947', 'D18-6948', 'D18-6949', 'D18-6950', 'D18-6951', 'D18-6952', 'D18-6953', 'D18-6954', 'D18-6955', 'D18-6956', 'D18-6957', 'D18-6958', 'D18-6959', 'D18-6960', 'D18-6961']
line.append('\t'.join(files))
a='\n'.join(line)
a=a+'\n'
with open('tRNA_counts/ALLcount_bytRNA_eValculled.txt', 'w') as fo:
    fo.write(a)