#!/bin/bash
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

module load python3/3.6.4
echo "tabulate total number and number of FL RNA alignments; nodes: 1; mem: 5G"
echo "Start - `date`"
echo "----"

if rm -f tRNA_counts/FLcount_bytRNA_eValculled.txt; then
	echo "old tRNA_counts/FLcount_bytRNA_eValculled.txt was removed"
fi
if rm -f tRNA_counts/ALLcount_bytRNA_eValculled.txt; then
	echo "old tRNA_counts/ALLcount_bytRNA_eValculled.txt was removed"
fi

python submit_13e_headerrow_tRNA.py
echo "new count summary files written"

for f in $(ls tRNA_13_tempcounts/*_maxeVal_FL.txt)
do
	g=$(basename $f|cut -f1 -d ".")
	printf "${g}\t" >> tRNA_counts/FLcount_bytRNA_eValculled.txt
	cat $f | cut -f2 -d "," | xargs | sed -E "s/ /\t/g" >> tRNA_counts/FLcount_bytRNA_eValculled.txt
	echo "${g}: tRNA_counts/FLcount_bytRNA_eValculled.txt written"
done

for f in $(ls tRNA_13_tempcounts/*maxeVal_all.txt)
do
	g=$(basename $f|cut -f1 -d ".")
	printf "${g}\t" >>tRNA_counts/ALLcount_bytRNA_eValculled.txt
	cat $f | cut -f2 -d "," | xargs | sed -E "s/ /\t/g" >> tRNA_counts/ALLcount_bytRNA_eValculled.txt
	echo "${g}: tRNA_counts/ALLcount_bytRNA_eValculled.txt written"
done

echo "----"
echo "Finish - `date`"
