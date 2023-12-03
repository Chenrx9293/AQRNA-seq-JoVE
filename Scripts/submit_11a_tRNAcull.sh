#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

module load python3/3.6.4
echo "cull; 5G memory, 2 nodes"
echo "----"
start="`date +%s`"
for f in `ls tRNA_08-10_blast/*_1.tRNAblast_paired`
do
t=`basename $f | cut -f2 -d "_"`
python submit_11b_tRNAcull.py $f $t
done
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
