#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

echo "restrict to read 2 sequences > 10bp; nodes: 1; mem: 29G"
echo "Start - `date`"
echo "----"
for f in `ls fastq/*/*.rc3clipped.fq_trimNN`
do
	start="`date +%s`"
	t=`echo $f| cut -f1 -d "."`
	echo "${t}.10bp.fa"
	./submit_07b_len10.pl $f ${t}.10bp.fa
	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
done
echo "----"
echo "Finish - `date`"
