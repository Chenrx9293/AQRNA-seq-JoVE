#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "Remove assignments > 0.001 eVal; nodes: 1; mem: 24G"
echo "----"
target="Ala-GGC-1 Ala-TGC-1 Arg-ACG-1 Arg-CCG-1 Arg-CCT-1 Arg-TCT-1 Asn-GTT-1 Asp-GTC-1 Cys-GCA-1 Gln-CTG-1 Gln-TTG-1 Glu-TTC-1 Gly-CCC-1 Gly-GCC-1 Gly-TCC-1 His-GTG-1 Ile-GAT-1 Ile2-CAT-1 Ile2-CAT-2 Leu-CAA-1 Leu-CAG-1 Leu-CAG-2 Leu-GAG-1 Leu-TAA-1 Leu-TAG-1 Lys-TTT-1 Met-CAT-1 Phe-GAA-1 Phe-GAA-2 Pro-CGG-1 Pro-GGG-1 Pro-TGG-1 SeC-TCA-1 Ser-CGA-1 Ser-GCT-1 Ser-GGA-1 Ser-TGA-1 Thr-CGT-1 Thr-CGT-2 Thr-GGT-1 Thr-GGT-2 Thr-TGT-1 Trp-CCA-1 Tyr-GTA-1 Tyr-GTA-2 Val-GAC-1 Val-GAC-2 Val-TAC-1 fMet-CAT-1 fMet-CAT-2 80mer_40GC 80mer_50GC 80mer_60GC"

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

