#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 4

module add blast/2.6.0
echo "blast read1; nodes: 1; mem: 29G"
echo "----"
for f in `ls fastq/*/*_1_sequence.10bp.fa`
do
    start="`date +%s`"
    t=`basename $f|cut -f1-3 -d "_"`
    out="tRNA_08-10_blast/${t}.tRNAblast"
    echo $out
    blastn -num_threads 8 -db Reference_Sequence.fasta -query $f -outfmt 6 -perc_identity 90 -word_size 9 -dust no -soft_masking false -out $out
    end="`date +%s`"
    echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
done
echo "----"
echo "Finish - `date`"
