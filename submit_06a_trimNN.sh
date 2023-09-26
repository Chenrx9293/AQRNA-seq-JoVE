#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

module load python3/3.6.4
echo "trimNN from clipped read 1 and rc read 2 sequences; nodes: 1; mem: 29G"
echo "Start - `date`"
echo "----"
for f in `ls fastq/*/*1_sequence.3clipped.fq` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq
do
	start="`date +%s`"
	b=`echo $f | cut -d "_" -f1-3` # fastq/180719Ded_D18-6947/180719Ded_D18-6947
	echo $b
	python submit_06b_trimNN.py ${b}_1_sequence.3clipped.fq # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq
	python submit_06b_trimNN.py ${b}_2_sequence.rc3clipped.fq # fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq

	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
done


echo "----"
echo "Finish - `date`"
