#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "Pull out alignments to BCG tRNAs, and standards from each no dupe file; 1 node, 25G mem"
echo "Start - `date`"
echo "----"
target="Olg_25 Olg_40 Olg_60 Olg_80_1 Olg_80_2 Internal_80"

for f in `ls tRNA_11_culledfileout/*_culled_nodupe.txt` # tRNA_11_culledfileout/D18-6947_culled_nodupe.txt
do
	for tRNA in $target # Olg_25
	do
		basename=`basename $f | cut -f1 -d "_"` # D18-6947
		echo "file=${f}, tRNA=${tRNA}"
		grep $tRNA[^0-9] $f > tRNA_12_grepped/${basename}_${tRNA} # tRNA_12_grepped/D18-6947_Olg_25
		echo "outputfile=tRNA_12_grepped/${basename}_${tRNA}"
	done
done
echo "----"
echo "Finish - `date`"


