#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "grep linkers; nodes: 2; mem: 29G"
echo "Start - `date`"
echo "----"
linkerseq="TGCCCGAGTG CACTCGGGCA AGGCTCTTCA TGAAGAGCCT" # order: 1, 1_rc, 2, 2_rc
for f in `ls fastq/*/*_[12]_sequence.fastq` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.fastq
do
start="`date +%s`"
	echo $f
	echo ${f}>${f}_linkercount # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.fastq_linkercount
	for linker in $linkerseq
	do
		seqcount=`grep -F $linker $f | wc -l`
		echo "linker      = $linker"
		echo "${linker}\t${seqcount}">>${f}_linkercount # line 1: full length linker count
		linker3to10=`echo $linker|cut -c3-10`
		seqcount3to10=`grep -F $linker3to10 $f |wc -l`
		echo "linker3to10 = --$linker3to10"
		echo "${linker3to10}\t${seqcount3to10}">>${f}_linkercount # line 2: 8nt linker count (3-10 is for linker 1 and 2)
		linker1to8=`echo $linker|cut -c1-8`
		seqcount1to8=`grep -F $linker1to8 $f |wc -l`
		echo "linker1to8  = $linker1to8--"
		echo "${linker1to8}\t${seqcount1to8}">>${f}_linkercount # line 3: 8nt linker count (1-8 is for linker 1 and 2 rc)
	done
	echo "Grep file written: ${f}_linkercount"

end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
echo "---"
done

for f in `ls fastq/*/*fastq_linkercount` #f=fastq/*/201215Ded_D20-6998_1_sequence.fastq_linkercount
do
	#echo $f
	wc -l $f>>_2_linkercount_linecheck
	cat $f>>_2_linkercount
done # output: _2_linkercount, _2_linkercount_linecheck
module load python3/3.6.4
python submit_02b_format.py _2_linkercount #output: linkercount_formatted

echo "----"
echo "Finish - `date`"
