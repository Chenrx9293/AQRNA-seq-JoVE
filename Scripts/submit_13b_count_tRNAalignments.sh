#!/bin/bash
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

module load python3/3.6.4
echo "count total number and number of FL alignments from non-dupe files; nodes: 2; mem: 15G"
echo "Start - `date`"
echo "----"
target="Ala-GGC-1 Ala-TGC-1 Arg-ACG-1 Arg-CCG-1 Arg-CCT-1 Arg-TCT-1 Asn-GTT-1 Asp-GTC-1 Cys-GCA-1 Gln-CTG-1 Gln-TTG-1 Glu-TTC-1 Gly-CCC-1 Gly-GCC-1 Gly-TCC-1 His-GTG-1 Ile-GAT-1 Ile2-CAT-1 Ile2-CAT-2 Leu-CAA-1 Leu-CAG-1 Leu-CAG-2 Leu-GAG-1 Leu-TAA-1 Leu-TAG-1 Lys-TTT-1 Met-CAT-1 Phe-GAA-1 Phe-GAA-2 Pro-CGG-1 Pro-GGG-1 Pro-TGG-1 SeC-TCA-1 Ser-CGA-1 Ser-GCT-1 Ser-GGA-1 Ser-TGA-1 Thr-CGT-1 Thr-CGT-2 Thr-GGT-1 Thr-GGT-2 Thr-TGT-1 Trp-CCA-1 Tyr-GTA-1 Tyr-GTA-2 Val-GAC-1 Val-GAC-2 Val-TAC-1 fMet-CAT-1 fMet-CAT-2 80mer_40GC 80mer_50GC 80mer_60GC"

for tRNA in $target
do
	newpath="tRNA_13_tempcounts"
	if rm -f ${newpath}/${tRNA}_all.txt; then
		echo "Old ${newpath}/${tRNA}_all.txt was removed"
	fi
	if rm -f ${newpath}/${tRNA}_FL.txt; then
		echo "Old ${newpath}/${tRNA}_FL.txt was removed"
	fi

	maxlength=$(python submit_13d_maxlength.py $tRNA Reference_Sequence.fasta)
	
	l=$((maxlength-5))

	for f in `ls tRNA_12_grepped/*${tRNA}_maxeVal`
	do
		filen=`basename $f` 
		fileshort=$(echo $filen|cut -f1 -d "_") 
		echo "filein=${f}"
		
		awk -v l="$l" '$5>l' $f > ${newpath}/${filen}_withEnd        
		length2=`wc -l ${f}| cut -f1 -d " "`                         
		length3=`wc -l ${newpath}/${filen}_withEnd | cut -f1 -d " "` 

		echo "${fileshort},${length2}" >> ${newpath}/${tRNA}_maxeVal_all.txt 
		echo "${fileshort},${length3}" >> ${newpath}/${tRNA}_maxeVal_FL.txt  
	done
	
	echo "${newpath}/${tRNA}_maxeVal_all.txt printed"
	echo "${newpath}/${tRNA}_maxeVal_FL.txt printed"
done

echo "----"
echo "Finish - `date`"
