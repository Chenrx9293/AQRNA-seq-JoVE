
#!/bin/sh

# NOTE: This master script is customized for cluster computing on Luria, which is Linux cluster hosted by the BioMicro Center at MIT.
# Luria uses SLURM as the job scheduler to manage jobs. Therefore, we have to use "sbatch [script_file]" to submit jobs to the cluster.
# If your computing cluster uses other job schedulers, you need to modify the lines associated with submitting jobs accordingly.
# If you do not use cluster computing, you can (i) change the "sbatch" in this file and all the .sh files to "sh" and (ii) delete the header lines
# in all the .sh files that start with "#SBATCH".
##---------------------------------------------------------------------------------------------
## Step 1: count the number of raw sequence reads
sbatch submit_01a_seqcount.sh
# Refers to submit_01b_format.py
# Input: 180719Ded_D18-6934_1_sequence.fastq; 180719Ded_D18-6934_2_sequence.fastq
# Output: _1_seqcount
# For the formatting step, changes were made for the script to run through
##---------------------------------------------------------------------------------------------
## Step 2: count the number of 5' and 3' adapters and their reverse complements
sbatch submit_02a_grep_FAST.sh
# Input: 180719Ded_D18-6947_1_sequence.fastq; 180719Ded_D18-6947_2_sequence.fastq
# Output: _2_linkercount_linecheck, _2_linkercount, _2_linkercount_formatted.txt
# The forward reads contained a large number of Linker1 reverse complements
# The reverse reads contained a large number of Linker2 reverse complements
# This was cross-verified by the linker clipping step
# For the formatting step, changes were made for the script to run through
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




################################################################################################
####Grep miRNAs from *10bp.fa (read 1 only)
mkdir miRNA_14_grepped
qsub -q all.q@n[^8]* submit_14a_grep_miRNA_read1.sh
#18 mins total
#refers to miRXploreUR_coded.txt for miRNA sequences
#input: fastq/180719Ded_D18-6932_1_sequence.10bp.fa
#output: miRNA_14_grepped/D18-6932_1_grepped.txt

####when complete, lscolor should yield 36 files:
lscolor miRNA_14_grepped/*_1_grepped.txt | wc -l
36

####Grep miRNAs from *10bp.fa (read 2 only)
qsub -q all.q@n[^8]* submit_14a_grep_miRNA_read2.sh
#18 mins total
#refers to miRXploreUR_coded.txt for miRNA sequences
#input: fastq/180719Ded_D18-6932_2_sequence.10bp.fa
#output: miRNA_14_grepped/D18-6932_2_grepped.txt

####when complete, lscolor should yield 36 files:
lscolor miRNA_14_grepped/*_2_grepped.txt | wc -l
36

################################################################################################
####Tabulate grepped miRNAs
mkdir miRNA_counts
qsub -q all.q@n[^8]* submit_14b_tabulate_miRNA.sh
#input: miRNA_14_grepped/D18-6932_1_grepped.txt
#output: miRNA_counts/miRNA_read1_counts.txt

#input: miRNA_14_grepped/D18-6932_2_grepped.txt
#output: miRNA_counts/miRNA_read2_counts.txt

#output: miRNA_counts/miRNA_counts.txt

################################################################################################
####Organize culled grep files by sample to use for matlab plotting
mkdir tRNA_matlab1
mkdir tRNA_matlab1/tRNAcountsbySample
qsub submit_15a_matlab_culledforplotting.sh
#input: tRNA_12_grepped/D18-6932_tRNA-Ala-GGC-1-1
#output: tRNA_matlab1/tRNAcountsbySample/D18-6932.txt

####check file size for .txt files in tRNAcountsbySample
find /home/jenhu/180720_Unscrambled/tRNA_matlab1/tRNAcountsbySample -type f -name '*.txt' -exec du -ch {} + | grep total$
5.7G	total


####Run matlab script to generate alignment plot
matlab runPlot

################################################################################################
mkdir bwasequences
qsub -q all.q@n[^8]* submit_16a_len15.sh
#4 mins for read 1; 3 mins for read 2
#refers to submit_16b_len15.pl
#input: fastq/180719Ded_D18-6932_1_sequence.3clipped.fq
#output: bwasequences/180719Ded_D18-6932_1_sequence.long15bp.fq
#input: fastq/180719Ded_D18-6932_2_sequence.3clipped.fq
#output: bwasequences/180719Ded_D18-6932_2_sequence.long15bp.fq

################################################################################################
qsub -q all.q@n[^8]* submit_16c_bwa_step1.sh
#6 mins total
#refers to submit_16d_fastQCombinePairedEnd.py
#input: bwasequences/180719Ded_D18-6932_1_sequence.long15bp.fq
#		bwasequences/180719Ded_D18-6932_2_sequence.long15bp.fq
#output: bwasequences/180719Ded_D18-6932_paired1.fq
#		 bwasequences/180719Ded_D18-6932_paired2.fq
#		 bwasequences/180719Ded_D18-6932_singles.fq

################################################################################################
module add bwa/0.7.12
bwa index BCG.fasta
[bwa_index] Pack FASTA... 0.04 sec
[bwa_index] Construct BWT for the packed sequence...
[bwa_index] 1.97 seconds elapse.
[bwa_index] Update BWT... 0.03 sec
[bwa_index] Pack forward-only FASTA... 0.03 sec
[bwa_index] Construct SA from BWT and Occ... 0.51 sec
[main] Version: 0.7.12-r1039
[main] CMD: bwa index BCG.fasta
[main] Real time: 3.115 sec; CPU: 2.590 sec
################################################################################################
qsub -q all.q@n[^8]* submit_16e_bwa_step2.sh
#read 1: 17:25-17:38, 13 minutes; lscolor -t *2981844*
#read 2: 17:37-17:53, 16 minutes; lscolor -t *2981845*
#input: bwasequences/180719Ded_D18-6932_paired1.fq
#output: bwasequences/180719Ded_D18-6932_paired1.sai
#input: bwasequences/180719Ded_D18-6932_paired2.fq
#output: bwasequences/180719Ded_D18-6932_paired2.sai

#bwa "error" output example (vi submit_16e_bwa_step2.sh.e2981844.32):
 #  1 [bwa_aln] 17bp reads: max_diff = 2
 #  2 [bwa_aln] 38bp reads: max_diff = 3
 #  3 [bwa_aln] 64bp reads: max_diff = 4
 #  4 [bwa_aln] 93bp reads: max_diff = 5
 #  5 [bwa_aln] 124bp reads: max_diff = 6
 #  6 [bwa_aln] 157bp reads: max_diff = 7
 #  7 [bwa_aln] 190bp reads: max_diff = 8
 #  8 [bwa_aln] 225bp reads: max_diff = 9
 #  9 [bwa_aln_core] calculate SA coordinate... 23.81 sec
 # 10 [bwa_aln_core] write to the disk... 0.01 sec
 # 11 [bwa_aln_core] 262144 sequences have been processed.
 # 12 [bwa_aln_core] calculate SA coordinate... 23.65 sec
 # 13 [bwa_aln_core] write to the disk... 0.02 sec
 # 14 [bwa_aln_core] 524288 sequences have been processed.
 # 15 [bwa_aln_core] calculate SA coordinate... 20.76 sec
 # 16 [bwa_aln_core] write to the disk... 0.01 sec
 # 17 [bwa_aln_core] 753310 sequences have been processed.
 # 18 [main] Version: 0.7.12-r1039
 # 19 [main] CMD: bwa aln -t 1 BCG.fasta bwasequences/180719Ded_D18-6932_paired1.fq
 # 20 [main] Real time: 71.657 sec; CPU: 69.280 sec

################################################################################################
qsub -q all.q@n[^8]* submit_16f_bwa_step3.sh
#00:32-00:40, 8 minutes
#input: bwasequences/180719Ded_D18-6932_paired1.sai
#		bwasequences/180719Ded_D18-6932_paired2.sai
#		bwasequences/180719Ded_D18-6932_paired1.fq
#		bwasequences/180719Ded_D18-6932_paired2.sai
#output: bwasequences/180719Ded_D18-6932.sam

#input: bwasequences/180719Ded_D18-6932.sam
#output: bwasequences/180719Ded_D18-6932.sort.bam

####check file size for .bam and .bam.bai files
find /home/jenhu/180720_Unscrambled/bwasequences -type f -name '*bam*' -exec du -ch {} + | grep total$
2.6G total

################################################################################################
####Copy .bam and .bai files to local folder:
rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress --append --compress-level=9 jenhu@bmc-pub4.mit.edu:"/home/jenhu/180720_Unscrambled/bwasequences/*.bam*" .

################################################################################################
####find where highest pileups are
qsub -q all.q@n[^8]* submit_17a_pileup.sh
#refers to submit_17b_pileup_sort.py
#input: 3clippedfq/180228Ded_D18-1609.sort.bam
#output: 3clippedfq/180228Ded_D18-1609.pileup

#input: 3clippedfq/180228Ded_D18-1609.pileup
#output: 3clippedfq/180228Ded_D18-1609.apileup
#		 3clippedfq/180228Ded_D18-1609.nontRNA.pileup


