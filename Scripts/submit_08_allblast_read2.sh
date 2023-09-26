#!/bin/sh
#$ -M jenhu@mit.edu
#$ -m e
#$ -V
#$ -cwd
#$ -l mem_free=29G
#$ -pe whole_nodes 1
#$ -t 6932-6967
###################
module add blast/2.4.0
echo "blast read1; nodes: 1; mem: 29G"
echo "----"
start="`date +%s`"
f="fastq/180719Ded_D18-${SGE_TASK_ID}_2_sequence.10bp.fa" #$f=fastq/180719Ded_D18-6932_2_sequence.10bp.fa
t=`basename $f|cut -f1-3 -d "_"` #$t=180719Ded_D18-6932_2
out="all_08-10_blast/${t}.allblast" #output=all_08-10_blast/180719Ded_D18-6932_2.allblast
echo $out #output=all_08-10_blast/180719Ded_D18-6932_2.allblast
blastn -num_threads 8 -db DNA_all_db.fasta -query $f -outfmt 6 -perc_identity 90 -word_size 9 -dust no -soft_masking false -out $out
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."