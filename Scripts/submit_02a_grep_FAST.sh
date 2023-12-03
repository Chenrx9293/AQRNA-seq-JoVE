#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

echo "grep linkers; nodes: 2; mem: 29G"
echo "Start - `date`"
echo "----"
linkerseq="TGCCCGAGTG CACTCGGGCA AGGCTCTTCA TGAAGAGCCT"
# Order of the sequences: Linker 1, Linker 1 reverse complement, Linker 2, Linker 2 reverse complement.
for f in `ls fastq/*/*_[12]_sequence.fastq`
do
start="`date +%s`"
	echo $f
	echo ${f}>${f}_linkercount
	for linker in $linkerseq
	do
		seqcount=`grep -F $linker $f | wc -l`
		echo "linker      = $linker"
		echo "${linker}\t${seqcount}">>${f}_linkercount
		linker3to10=`echo $linker|cut -c3-10`
		seqcount3to10=`grep -F $linker3to10 $f |wc -l`
		echo "linker3to10 = --$linker3to10"
		echo "${linker3to10}\t${seqcount3to10}">>${f}_linkercount
		linker1to8=`echo $linker|cut -c1-8`
		seqcount1to8=`grep -F $linker1to8 $f |wc -l`
		echo "linker1to8  = $linker1to8--"
		echo "${linker1to8}\t${seqcount1to8}">>${f}_linkercount
	done
	echo "Grep file written: ${f}_linkercount"

end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
echo "---"
done

for f in `ls fastq/*/*fastq_linkercount`
do
	wc -l $f>>_2_linkercount_linecheck
	cat $f>>_2_linkercount
done 
module load python3/3.6.4
python submit_02b_format.py _2_linkercount

echo "----"
echo "Finish - `date`"
