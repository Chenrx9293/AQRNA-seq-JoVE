#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "pair tRNAblast 1 and 2; nodes: 1; mem: 25G"
echo "----"

for f in `ls tRNA_08-10_blast/*_1.tRNAblast` # tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast
do
	start="`date +%s`"
	t=`echo $f|cut -f1-4 -d "_"` # tRNA_08-10_blast/180719Ded_D18-6947
	echo "writing ${t}_1.tRNAblast_paired..."
	./overlaphashPairedBlast.pl ${t}_1.tRNAblast ${t}_2.tRNAblast ${t}_1.tRNAblast_paired # tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast_paired
	echo "writing ${t}_2.tRNAblast_paired..."
	./overlaphashPairedBlast.pl ${t}_2.tRNAblast ${t}_1.tRNAblast ${t}_2.tRNAblast_paired # tRNA_08-10_blast/180719Ded_D18-6947_2.tRNAblast_paired
	end="`date +%s`"
	echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
done
