#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "create rc of clipped read 2; nodes: 1; mem: 27G"
echo "Start - `date`"
echo "----"

for f in `ls fastq/*/*_2_sequence.3clipped.fq` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.3clipped.fq
do
start="`date +%s`"

	echo $f
	t=`echo $f|cut -d "." -f1` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence
	./submit_05b_reverse_complement.pl ${f} ${t}.rc3clipped.fq # fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq
	echo "${t}.rc3clipped.fastq was written"

end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
echo "---"
done

echo "----"
echo "Finish - `date`"
