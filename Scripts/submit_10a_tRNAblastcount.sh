#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 4

echo "count mapped sequences; nodes: 1; mem: 500M"
echo "----"
start="`date +%s`"
for f in `ls tRNA_08-10_blast/*_1.tRNAblast`
do
t=`basename $f |cut -f2-3 -d "_"`
e=`echo $f |cut -f1 -d "."`
echo "e=$e"
i=`cut -f1 $f |sort -u  |wc -l`
echo "$((j=$i-1))\t${t}" >${e}.tRNAblastcount
echo "${e}.tRNAblastcount written"
done
echo "----"

for f in `ls tRNA_08-10_blast/*_2.tRNAblast`
do
t=`basename $f |cut -f2-3 -d "_"`
e=`echo $f |cut -f1 -d "."`
echo "e=$e"
i=`cut -f1 $f |sort -u  |wc -l`
echo "$((j=$i-1))\t${t}" >${e}.tRNAblastcount
echo "${e}.tRNAblastcount written"
done
echo "----"
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."