#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 4
#SBATCH --mail-type end
#SBATCH --mail-user=rc836@mit.edu

module add blast/2.6.0
echo "blast read1; nodes: 1; mem: 29G"
echo "----"
for f in `ls fastq/*/*_1_sequence.10bp.fa` # fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.10bp.fa
do
    start="`date +%s`"
    t=`basename $f|cut -f1-3 -d "_"` # 180719Ded_D18-6947_1
    out="tRNA_08-10_blast/${t}.tRNAblast" # tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast
    echo $out
    blastn -num_threads 8 -db Reference_Sequence.fasta -query $f -outfmt 6 -perc_identity 90 -word_size 9 -dust no -soft_masking false -out $out
    end="`date +%s`"
    echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."
done
echo "----"
echo "Finish - `date`"
