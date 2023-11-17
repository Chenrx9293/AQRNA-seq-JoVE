#!/bin/bash
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

module load python3/3.6.4
echo "count total number and number of FL alignments from non-dupe files; nodes: 2; mem: 15G"
echo "Start - `date`"
echo "----"
target="Olg_25 Olg_40 Olg_60 Olg_80_1 Olg_80_2 Internal_80"

for tRNA in $target
do
	newpath="tRNA_13_tempcounts"
	if rm -f ${newpath}/${tRNA}_all.txt; then
		echo "Old ${newpath}/${tRNA}_all.txt was removed"
	fi
	if rm -f ${newpath}/${tRNA}_FL.txt; then
		echo "Old ${newpath}/${tRNA}_FL.txt was removed"
	fi

	maxlength=$(python submit_13d_maxlength.py $tRNA E_coli_BW25113_tRNA_RefSeqLib_RC_2023_10_17.fasta)
	## make sure fasta file matches target ^^^^^
	l=$((maxlength-5))

	for f in `ls tRNA_12_grepped/*${tRNA}_maxeVal` # tRNA_12_grepped/D18-6947_Olg_25_maxeVal
	do
		filen=`basename $f` # D18-6947_Olg_25_maxeVal
		fileshort=$(echo $filen|cut -f1 -d "_") # D18-6947
		echo "filein=${f}"
		
		awk -v l="$l" '$5>l' $f > ${newpath}/${filen}_withEnd        # tRNA_13_tempcounts/D18-6947_Olg_25_maxeVal_withEnd
		length2=`wc -l ${f}| cut -f1 -d " "`                         # length2: length of tRNA_12_grepped/D18-6947_Olg_25_maxeVal
		length3=`wc -l ${newpath}/${filen}_withEnd | cut -f1 -d " "` # length3: length of tRNA_13_tempcounts/D18-6947_Olg_25_maxeVal_withEnd

		echo "${fileshort},${length2}" >> ${newpath}/${tRNA}_maxeVal_all.txt # tRNA_13_tempcounts/Olg_25_maxeVal_all.txt
		echo "${fileshort},${length3}" >> ${newpath}/${tRNA}_maxeVal_FL.txt  # tRNA_13_tempcounts/Olg_25_maxeVal_FL.txt
	done
	
	echo "${newpath}/${tRNA}_maxeVal_all.txt printed"
	echo "${newpath}/${tRNA}_maxeVal_FL.txt printed"
done

echo "----"
echo "Finish - `date`"
