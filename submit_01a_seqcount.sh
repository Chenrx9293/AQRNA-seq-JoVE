#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "count all reads; nodes: 1; mem: 10G"
echo "Start - `date`"
echo "----"
for f in `ls fastq/*/*_[12]_sequence.fastq` #f=fastq/*/201215Ded_D20-6998_1_sequence.fastq
do
	start="`date +%s`"
	l=`wc -l $f|cut -f1 -d " "`
	a=$((l/4))
	echo "${a} sequences in ${f}"
	echo "${a}\t${f}" >${f}_readcount
	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
done
head fastq/*/*fastq_readcount >_1_seqcount
echo "seqcount written"
module load python3/3.6.4
python submit_01b_format.py _1_seqcount
echo "----"
echo "Finish - `date`"
