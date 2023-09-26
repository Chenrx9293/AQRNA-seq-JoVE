#!/bin/sh
#$ -M jenhu@mit.edu
#$ -m e
#$ -V
#$ -cwd
#$ -l mem_free=29G
#$ -pe whole_nodes 1
#$ -t 32-67
###################
echo "pair allblast 1 and 2; nodes: 1; mem: 29G"
echo "----"
start="`date +%s`"
f="all_08-10_blast/180719Ded_D18-69${SGE_TASK_ID}_1.allblast" #$f=all_08-10_blast/180719Ded_D18-6932_1.allblast
t=`echo $f|cut -f1-4 -d "_"` #$t=all_08-10_blast/180719Ded_D18-6932
echo "writing ${t}_1.allblast_paired..."
./DuanScripts/overlaphashPairedBlast.pl ${t}_1.allblast ${t}_2.allblast ${t}_1.allblast_paired #all_08-10_blast/180719Ded_D18-6932_1.allblast_paired
echo "writing ${t}_2.allblast_paired..."
./DuanScripts/overlaphashPairedBlast.pl ${t}_2.allblast ${t}_1.allblast ${t}_2.allblast_paired #all_08-10_blast/180719Ded_D18-6932_2.allblast_paired
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
