#!/bin/sh
#$ -M jenhu@mit.edu
#$ -m e
#$ -V
#$ -cwd
#$ -l mem_free=500M
#$ -pe whole_nodes 1
#$ -t 6998-7015
###################
echo "count mapped sequences; nodes: 1; mem: 500M"
echo "----"
start="`date +%s`"

f="sRNA_blast/201215Ded_D20-${SGE_TASK_ID}_1.allblast" #$f=sRNA_blast/201215Ded_D20-6998_1.allblast
t=`basename $f |cut -f3-4 -d "_"` #$t=D20-6998_1.allblast
e=`echo $f |cut -f1 -d "."` #$e=sRNA_blast/201215Ded_D20-6998_1
echo "e=$e"
i=`cut -f1 $f |sort -u  |wc -l` 
echo "$((j=$i-1))\t${t}" >${e}.allblastcount #$f=sRNA_blast/201215Ded_D20-6998_1.allblastcount
echo "${e}.allblastcount written"

f="sRNA_blast/201215Ded_D20-${SGE_TASK_ID}_2.allblast" #$f=sRNA_blast/201215Ded_D20-6998_2.allblast
t=`basename $f |cut -f3-4 -d "_"` #$t=D20-6998_2.allblast
e=`echo $f |cut -f1 -d "."` #$e=sRNA_blast/201215Ded_D20-6998_2
echo "e=$e"
i=`cut -f1 $f |sort -u  |wc -l` 
echo "$((j=$i-1))\t${t}" >${e}.allblastcount #$f=sRNA_blast/201215Ded_D20-6998_2.allblastcount
echo "${e}.allblastcount written"

echo "----"
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
