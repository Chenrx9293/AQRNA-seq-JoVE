#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

module load python3/3.6.4
echo "cull; 5G memory, 2 nodes"
echo "----"
start="`date +%s`"
for f in `ls tRNA_08-10_blast/*_1.tRNAblast_paired` # tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast_paired
do
t=`basename $f | cut -f2 -d "_"` # D18-6947
python submit_11b_tRNAcull.py $f $t
#output: tRNA_11_culledfileout/D18-6947_culled.txt
#output: tRNA_11_culledfileout/D18-6947_culled_disc.txt
#output: tRNA_11_culledfileout/D18-6947_culled_nodupe.txt
done
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
