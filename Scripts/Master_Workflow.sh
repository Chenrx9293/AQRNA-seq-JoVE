
#!/bin/sh

# NOTE: This master script is customized for cluster computing on Luria, which is Linux cluster hosted by the BioMicro Center at MIT.
# Luria uses SLURM as the job scheduler to manage jobs. Therefore, we have to use "sbatch [script_file]" to submit jobs to the cluster.
# If your computing cluster uses other job schedulers, you need to modify the lines associated with submitting jobs accordingly.
# If you do not use cluster computing, you can (i) change the "sbatch" in this file and all the .sh files to "sh" and (ii) delete the header lines
# in all the .sh files that start with "#SBATCH".
##---------------------------------------------------------------------------------------------
## Step 1: count the number of raw sequence reads
sbatch submit_01a_seqcount.sh
# Input files: quality-filtered raw sequence reads in FASTQ format (details on how to prepare the input files can be found in the section "set up directories and prepare files")
# Output files
# - _1_seqcount: the number of quality-filtered raw sequence reads in each FASTQ file.
# - _1_seqcount_formatted.txt: _1_seqcount reorganized into tabulate format.
##---------------------------------------------------------------------------------------------
## Step 2: count the number of 5' and 3' adapters and their reverse complements
sbatch submit_02a_grep_FAST.sh
# Description: this step verified the sequencing process by enumerating the occurrence of linker sequences and their reverse complements in the sequencing reads.
# For paired-end sequence reads, expect a high count of Linker 1 sequence in the forward reads and a high count of Linker 2 sequence in the reverse reads.
# For single-end sequence reads, expect a high count of Linker 1 sequence in the reads.
# Input: fastq/221222Ded_D22-12879/221222Ded_D22-12879_1_sequence.fastq; fastq/221222Ded_D22-12879/221222Ded_D22-12879_2_sequence.fastq
# Output: _2_linkercount_linecheck; _2_linkercount; _2_linkercount_formatted.txt
##---------------------------------------------------------------------------------------------
## Step 3: strip 3' adapter from reads 1 and 2
# better clipping by Jennifer Hu:
# -M 8 requires minimum 8 bp of match to 10 nt adapter. This allows short inserts to be better filtered out.
# -n allows sequences with N to be retained
sbatch submit_03_3clip.sh 
# 2-7 mins per file
# Clip CACTCGGGCA from read 1
# Input: 180719Ded_D18-6947_1_sequence.fastq
# Output: 180719Ded_D18-6947_1_sequence.3clipped.fq
sbatch submit_03_3clip_read2.sh
# 2-7 mins per file
# Clip TGAAGAGCCT from read 2
# Input: 180719Ded_D18-6947_2_sequence.fastq
# Output: 180719Ded_D18-6947_2_sequence.3clipped.fq
##---------------------------------------------------------------------------------------------
## Step 4: count sequences after 3' clipping
sbatch submit_04a_3clipcount.sh
# 2-17 seconds per file
# Refers to submit_4b_format.py
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq
# output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped_readcount; _3_3clippedcount; _3_3clippedcount_formatted.txt
# For the formatting step, changes were made for the script to run through
##---------------------------------------------------------------------------------------------
## Step 5: generate RC of read 2
sbatch submit_05a_rcread2.sh
# 10-40 seconds per file
# Refers to submit_05b_reverse_complement.pl
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.3clipped.fq
# Output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq
grep -A1 @NS500496_541_H35G7BGX5:1:11101:11556:2227#CACCGTTGTGTG/2 fastq/180215Ded_D18-1331_2_sequence.3clipped.fq
@NS500496_541_H35G7BGX5:1:11101:11556:2227#CACCGTTGTGTG/2
AGGGTGAGGTCCCCAGTTCGACTCTGGGTATCAGCACCACA
##---------------------------------------------------------------------------------------------
## Step 6: trim NN from linker1 for reads 1 and 2
sbatch submit_06a_trimNN.sh
# Refers to submit_06b_trimNN.py
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq
# Output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq_trimNN
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq
# Output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq_trimNN
##---------------------------------------------------------------------------------------------
## Step 7: restrict to fragments longer than 10bp after stripping adapters and NN from read 1 and rc read 2'
## NOTE: can qsub submit_07a... when 34/36 done with submit_06a...
sbatch submit_07a_len10_read1.sh 
# 8-60 seconds per sample
# Refers to submit_07b_len10.pl
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.3clipped.fq_trimNN
# Output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.10bp.fa
sbatch submit_07a_len10_read2.sh
# 8-60 seconds per sample
# Refers to submit_07b_len10.pl
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.rc3clipped.fq_trimNN
# Output: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.10bp.fa
##---------------------------------------------------------------------------------------------
## Check number of lines in *.10bp.fa files
for f in `ls fastq/*10bp.fa`; do wc -l $f; done > _4_trimmedCount
# The numbers of sequences in the files matched to the numbers obtained from the previous run
##---------------------------------------------------------------------------------------------
## Batch check file sizes
# This step was skipped, as only one file was processed
filetypes="*1_sequence.fastq *2_sequence.fastq *1_sequence.3clipped.fq
*2_sequence.3clipped.fq *2_sequence.rc3clipped.fq *.3clipped.fq_trimNN
*.rc3clipped.fq_trimNN"
for f in $filetypes
do
echo $f
find /home/jenhu/180720_Unscrambled/fastq -type f -name $f -exec du -ch {} + | grep total$
done
*1_sequence.fastq
54G	total
*2_sequence.fastq
54G	total
*1_sequence.3clipped.fq
20G	total
*2_sequence.3clipped.fq
20G	total
*2_sequence.rc3clipped.fq
20G	total
*.3clipped.fq_trimNN
19G	total
*.rc3clipped.fq_trimNN
19G	total

## Check file size for a single filetype
# This step was skipped, as only one file was processed
find /home/jenhu/180720_Unscrambled/fastq -type f -name '*.10bp.fa' -exec du -ch {} + | grep total$
15G total

##---------------------------------------------------------------------------------------------
## Step 8: blast analysis
## Make the db for blast analysis
module load blast/2.6.0
makeblastdb -in StdOlg_Sequence.fasta -parse_seqids -dbtype nucl
## Make blast directory
mkdir tRNA_08-10_blast
## Perform blast analysis 
# StdOlg_Sequence.fasta was used as the db
sbatch  submit_08_tRNAblast_read1.sh
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_1_sequence.10bp.fa
# Output: tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast
sbatch submit_08_tRNAblast_read2.sh
# Input: fastq/180719Ded_D18-6947/180719Ded_D18-6947_2_sequence.10bp.fa
# Output: tRNA_08-10_blast/180719Ded_D18-6947_2.tRNAblast
##---------------------------------------------------------------------------------------------
## Check blast
find . -type f -name '*_1.tRNAblast' -exec du -ch {} + | grep total$
# 2.9G	total
find . -type f -name '*_2.tRNAblast' -exec du -ch {} + | grep total$
# 2.9G	total
##---------------------------------------------------------------------------------------------
## Step 9: pair blast mapped reads
sbatch submit_09_tRNAblastpair.sh
# Refers to DuanScripts/overlaphashPairedBlast.pl
# Input: tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast tRNA_08-10_blast/180719Ded_D18-6947_2.tRNAblast
# Output: tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast_paired
# Input: tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast tRNA_08-10_blast/180719Ded_D18-6947_2.tRNAblast
# Output: tRNA_08-10_blast/180719Ded_D18-6947_2.tRNAblast_paired

find /home/jenhu/180720_Unscrambled/tRNA_08-10_blast -type f -name '*_1.tRNAblast_paired' -exec du -ch {} + | grep total$
23G	total

find /home/jenhu/180720_Unscrambled/tRNA_08-10_blast -type f -name '*_2.tRNAblast_paired' -exec du -ch {} + | grep total$
23G	total

find /home/jenhu/180720_Unscrambled/all_08-10_blast -type f -name '*_1.allblast_paired' -exec du -ch {} + | grep total$
49G total

find /home/jenhu/180720_Unscrambled/all_08-10_blast -type f -name '*_2.allblast_paired' -exec du -ch {} + | grep total$
49G	total
##---------------------------------------------------------------------------------------------
## Step 10: count number of sequences aligned by blast
sbatch submit_10a_tRNAblastcount.sh
# Input: tRNA_08-10_blast/180719Ded_D18-6934_1.tRNAblast
# Output: tRNA_08-10_blast/180719Ded_D18-6934_1.tRNAblastcount
# Input: tRNA_08-10_blast/180719Ded_D18-6934_2.tRNAblast
# Output: tRNA_08-10_blast/180719Ded_D18-6934_2.tRNAblastcount

for f in tRNA_08-10_blast/*tRNAblastcount; do cat $f; done > _5_tRNAblastcount
module load python3/3.6.4
python submit_10c_blastcount.py # make sure filename in script matches _5_blastcount
# The formatting step was skipped

##---------------------------------------------------------------------------------------------
## Step 11: cull alignments by selecting best alignment scores (must wait until 9 finishes before starting 11a)
mkdir tRNA_11_culledfileout
sbatch submit_11a_tRNAcull.sh
# Only the forward read file (e.g., tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast_paired) was culled
# It was assumed that the culled results for the reverse read file should be very similar to that for the forward read file
# Refers to submit_11b_tRNAcull.py
# Input: tRNA_08-10_blast/180719Ded_D18-6947_1.tRNAblast_paired
# Output: tRNA_11_culledfileout/D18-6947_culled.txt
# Output: tRNA_11_culledfileout/D18-6947_culled_disc.txt
# Output: tRNA_11_culledfileout/D18-6947_culled_nodupe.txt

# NOTE: submit_11b_cull.py does the following:
# 1. input: paired read alignments
# 2. combined paired read positions - min start, max end, summed bitscore
# 3. create a dict that keeps read alignments with smallest eVals, longest length, and largest bScore, and discard alignments that were less well matched.
# 4. of remaining read alignments, divide into "no dupe" and "discard" and write as output

##---------------------------------------------------------------------------------------------
## Step 12: pull out individual tRNA alignments from each no dupe file
#first:
mkdir tRNA_12_grepped
sbatch submit_12a_nodupe_tRNA.sh
# Input: tRNA_11_culledfileout/D18-6947_culled_nodupe.txt
# Output: tRNA_12_grepped/D18-6947_Olg_25, etc.

##---------------------------------------------------------------------------------------------
## Step 13: create the frequency matrix (subjects as rows and samples as columns)

## Remove matches with eVal > 0.001
sbatch submit_13a_recull_eVal_tRNA.sh
# Input: tRNA_12_grepped/D18-6947_Olg_25, etc.
# Output: tRNA_12_grepped/D18-6947_Olg_25_maxeVal, etc.
# This may be the step where most of the sequences got removed

## Count FULL and ALL length matches for tRNAs + standards or miRNAs + standards
mkdir tRNA_13_tempcounts
sbatch submit_13b_count_tRNAalignments.sh
# Refers to submit_13d_maxlength.py
# Refers to StdOlg_Sequence.fasta

# Part 1 input: all lengths - tRNA_12_grepped/D18-6947_Olg_25_maxeVal
# Part 1 output: full length only - tRNA_13_tempcounts/D18-6947_Olg_25_maxeVal_withEnd
# Part 2 input: all lengths - tRNA_12_grepped/D18-6947_Olg_25_maxeVal
# Part 2 output: tRNA_13_tempcounts/Olg_25_maxeVal_all.txt
# Part 3 input: full length only - tRNA_13_tempcounts/D18-6932_tRNA-Ala-GGC-1-1_withEnd
# Part 3 output: tRNA_13_tempcounts/Olg_25_maxeVal_FL.txt

## When complete, lscolor should yield same number of items in target:
ls -color tRNA_13_tempcounts/*FL.txt | wc -l
ls -color tRNA_13_tempcounts/*all.txt | wc -l
# This step was skipped as only one file was processed

##---------------------------------------------------------------------------------------------
## Format count files by combining separate tRNA counts into single table
mkdir tRNA_counts
sbatch submit_13e_formatCounts_tRNA.sh
# Refers to submit_13e_headerrow_tRNA.py
# Input: tRNA_13_tempcounts/tRNA-Ala-CGC-1-1_all.txt
# Output: tRNA_counts/FLcount_bytRNA_eValculled.txt; ALLcount_bytRNA_eValculled.txt

# When complete, check:
vi tRNA_counts/FLcount_bytRNA_eValculled.txt
vi tRNA_counts/ALLcount_bytRNA_eValculled.txt
##---------------------------------------------------------------------------------------------

