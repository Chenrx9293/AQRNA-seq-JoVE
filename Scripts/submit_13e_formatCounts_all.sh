#!/bin/bash
#$ -M jenhu@mit.edu
#$ -m e
#$ -V
#$ -cwd
#$ -l mem_free=5G
#$ -pe whole_nodes 1
###################
module load python/2.7.2
echo "tabulate total number and number of FL RNA alignments; nodes: 1; mem: 5G"
echo "Start - `date`"
echo "----"

if rm -f all_counts/FLcount_byRNA_eValculled.txt; then
	echo "old all_counts/FLcount_byRNA_eValculled.txt was removed"
fi
if rm -f all_counts/ALLcount_byRNA_eValculled.txt; then
	echo "old all_counts/ALLcount_byRNA_eValculled.txt was removed"
fi

python submit_13e_headerrow_all.py
echo "new count summary files written"

for f in $(ls all_13_tempcounts/*_maxeVal_FL.txt) #$f=all_13_tempcounts/tRNA-Ala-CGC-1-1_maxeVal_FL.txt
do
	g=$(basename $f|cut -f1 -d ".") #$g=tRNA-Ala-CGC-1-1_maxeVal_FL
	printf "${g}\t" >> all_counts/FLcount_byRNA_eValculled.txt
	cat $f | cut -f2 -d "," | xargs | sed -E "s/ /\t/g" >> all_counts/FLcount_byRNA_eValculled.txt
	echo "${g}: all_counts/FLcount_byRNA_eValculled.txt written"
done

for f in $(ls all_13_tempcounts/*_maxeVal_all.txt) #$f=all_13_tempcounts/tRNA-Ala-CGC-1-1_maxeVal_all.txt
do
	g=$(basename $f|cut -f1 -d ".") #$g=tRNA-Ala-CGC-1-1_maxeVal_all
	printf "${g}\t" >>all_counts/ALLcount_byRNA_eValculled.txt
	cat $f | cut -f2 -d "," | xargs | sed -E "s/ /\t/g" >> all_counts/ALLcount_byRNA_eValculled.txt
	echo "${g}: all_counts/ALLcount_byRNA_eValculled.txt written"
done

echo "----"
echo "Finish - `date`"
