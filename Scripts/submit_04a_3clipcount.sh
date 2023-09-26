#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "count 3' clipped reads; nodes: 1; mem: 10G"
echo "Start - `date`"
echo "----"
for f in `ls fastq/*/*_sequence.3clipped.fq` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq
do
	start="`date +%s`"
	l=`wc -l $f|cut -f1 -d " "` # returns line number only
	a=$((l/4))
	echo "${a} sequences in ${f}"
	t=`echo $f |cut -f1-2 -d "."`
	echo "${a}\t${f}" >${t}_readcount # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped_readcount
	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
done
head fastq/*/*3clipped_readcount >_3_3clippedcount
echo "_3_3clippedcount written"
module load python3/3.6.4
python submit_04b_format.py _3_3clippedcount
echo "----"
echo "Finish - `date`"
