#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "restrict to read 1 sequences > 10bp; nodes: 1; mem: 29G"
echo "Start - `date`"
echo "----"
for f in `ls fastq/*/*.3clipped.fq_trimNN` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq_trimNN
do
	start="`date +%s`"
	t=`echo $f| cut -f1 -d "."` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence
	echo "${t}.10bp.fa"
	./submit_07b_len10.pl $f ${t}.10bp.fa # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.10bp.fa
	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
done
echo "----"
echo "Finish - `date`"
