#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "Remove assignments > 0.001 eVal; nodes: 1; mem: 24G"
echo "----"
target="Olg_25 Olg_40 Olg_60 Olg_80_1 Olg_80_2 Internal_80"

for tRNA in $target
do

	for f in $(ls tRNA_12_grepped/*${tRNA}) # tRNA_12_grepped/D18-6947_Olg_25
	do
		basename=$(basename $f| cut -f1 -d "_") # D18-6947
		awk '{ if ($3 < 0.001) {print}}' ${f} > tRNA_12_grepped/${basename}_${tRNA}_maxeVal #tRNA_12_grepped/D18-6947_Olg_25_maxeVal
		echo "tRNA_12_grepped/${basename}_${tRNA}_maxeVal reculled (eVal < 0.001)"
	done
	echo "----"
	# for f in $(ls tRNA_12_grepped/*_maxeVal) #$f=tRNA_12_grepped/D18-6932_tRNA-Ala-CGC-1-1_maxeVal
	# do
	# 	mv "$f" "${f/_maxeVal/}"
	# 	echo "$f renamed"
	# done
done

