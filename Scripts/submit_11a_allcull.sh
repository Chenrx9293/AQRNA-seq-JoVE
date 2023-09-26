#!/bin/sh
#$ -M jenhu@mit.edu
#$ -m e
#$ -V
#$ -cwd
#$ -l mem_free=5G
#$ -pe whole_nodes 2
#$ -t 32-67
###################
module load python/2.7.2
echo "cull; 5G memory, 2 nodes"
echo "----"
start="`date +%s`"
f="all_08-10_blast/180719Ded_D18-69${SGE_TASK_ID}_1.allblast_paired" #$f=all_08-10_blast/180719Ded_D18-6932_1.allblast_paired
t=`basename $f | cut -f2 -d "_"` #$t=D18-6932
python submit_11b_allcull.py $f $t
#output: tRNA_11_culledfileout/D18-6932_culled.txt
#output: tRNA_11_culledfileout/D18-6932_culled_disc.txt
#output: tRNA_11_culledfileout/D18-6932_culled_nodupe.txt
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
