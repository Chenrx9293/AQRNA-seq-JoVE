#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

echo "count reads in culled_disc, culled_all, culled_nodupe; nodes: 1; mem: 500M"
echo "----"
start="`date +%s`"

for f in `ls tRNA_11_culledfileout/*` #$f=tRNA_11_culledfileout/D18-6932_culled_disc.txt
do
	t=`basename $f` #$t=D18-6932_culled_disc.txt
	echo "t=$t"
	i=`cut -f1 $f |sort -u  |wc -l` 
	echo "$((j=$i-1))\t${t}" >${f}_count 
	echo "${f}_count written" #tRNA_11_culledfileout/D18-6932_culled_disc.txt_count
done

for f in tRNA_11_culledfileout/*_disc.txt_count; do cat $f; done > _7_tRNA_culled_disc_count
for f in tRNA_11_culledfileout/*_nodupe.txt_count; do cat $f; done > _7_tRNA_culled_nodupe_count
for f in tRNA_11_culledfileout/*culled.txt_count; do cat $f; done > _7_tRNA_culled_all_count
module load python/2.7.2
python submit_11d_tRNAcullcount.py

echo "----"
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
