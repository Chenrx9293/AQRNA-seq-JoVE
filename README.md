# AQRNA-seq-JoVE
Instructions and scripts for running the data analytics pipeline of AQRNA-seq
# System and job scheduler
For demonstration purposes, both the master script and its associated sub-scripts are tailored for cluster computing on Luria, a Linux cluster hosted by the BioMicro Center at Massachusetts Institute of Technology, using SLURM as the job scheduler for job management. If your computing cluster operates with different job schedulers, you'll need to adjust the lines related to job submission accordingly. If you are not using cluster computing, you can make the following modifications: (i) change all instances of "sbatch" in the master script and all the .sh files to "sh" and (ii) delete the header lines beginning with "#SBATCH" in all .sh files.
# Set up directories and prepare files 
Setting up directories correctly and preparing all necessary files are of crucial importance for properly executing the data analytics pipeline of AQRNA-seq. Please complete the following steps before running the pipeline:
- Retrieve raw sequence reads from the external sequencing center and assess sequencing quality using open-source programs such as FastQC or fastp. 
- Create a directory named “AQRNA-seq” for execution of the data analytics pipeline and place all scripts provided here into this directory. 
- From within the ΑQRNA-seq directory, create a directory named “fastq” for storing the sequence reads (in FASTQ format) of all samples to be analyzed. From within the fastq directory, create a directory named "GroupID_SampleID" for each sample, where "SampleID" is a unique identifier for the sample and "GroupID" is any information (e.g., experimental trial) that could be used for dividing samples into distinct groups. Both "GroupID" and "SampleID" cannot contain underscores. Place the sequence read files of each sample into the corresponding directory, with the forward read file named in the format of "GroupID_SampleID_1_sequence.fastq" and the reverse read file named in the format of "GroupID_SampleID_2_sequence.fastq". 
- Generate a library file in the FASTA format with the name “Reference_Sequence.fasta” and place this file into the AQRNA-seq directory. This library file is key to the analysis of diverse small RNA species and thus should contain all reference sequences of the small RNA species of interest as well as positive and/or negative control sequences. Each reference sequence should have a unique header without spaces, and headers that are substrings of other headers should be avoided. For instance, we recommend against using both "Met-CAT-1" and "fMet-CAT-1" as headers, which can be substituted by "tRNA-Met-CAT-1" and "tRNA-fMet-CAT-1". 
- Modify line 10 of the submit_12a_nodupe_tRNA.sh file to supply reference sequence headers. 
- Modify line 9 of the submit_13a_recull_eVal_tRNA.sh file to supply reference sequence headers. 
- Modify line 11 of the submit_13b_count_tRNAalignments.sh file to supply reference sequence headers. 
If the steps within this section are properly executed, there is no need to prepare specific input files for individual steps within the "Run the pipeline" section below.
# Run the pipeline
All steps should be executed from within the AQRNA-seq directory.
## Step 1: Enumerate quality-filtered sequence reads
### Description:
This step involves enumerating the quality-filtered sequence reads within each FASTQ file. The counts for forward and reverse reads should be identical.
### Input files:
Quality-filtered sequence reads in FASTQ format for individual samples, as shown below. Detailed instructions on file preparation can be found in the section titled "Set up directories and prepare files". Please note that "GroupID" and "SampleID" within the path below are placeholders and should be replaced accordingly.
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.fastq 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.fastq 
### Output files:
A tabulate summary of the sequence read counts within each FASTQ file. 
- _1_seqcount_formatted.txt
### Command: 
sbatch submit_01a_seqcount.sh 
## Step 2: Enumerate 5' and 3' linkers and their reverse complements in sequence reads 
### Description:
This step verifies the sequencing process by enumerating the occurrence of linker sequences and their reverse complements in the quality-filtered sequence reads. Expect high counts for the Linker 1 sequence in forward reads and high counts for the Linker 2 sequence in reverse reads.
### Input files:
Quality-filtered sequence reads in FASTQ format for individual samples, as shown below. Detailed instructions on file preparation can be found in the section titled "Set up directories and prepare files". Please note that "GroupID" and "SampleID" within the path below are placeholders and should be replaced accordingly. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.fastq 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.fastq 
### Output files:
A tabulate summary of the counts of linkers and their reverse complements within each FASTQ file. 
- _2_linkercount_formatted.txt 
### Command: 
sbatch submit_02a_grep_FAST.sh
## Step 3: Trim 3' adaptor sequences from forward and reverse reads
### Description:
This step trims the 3' adaptor sequences from both forward and reverse reads. The sequence "CACTCGGGCA" is used for identification of the 3' adaptor sequence for the forward reads, while the sequence "TGAAGAGCCT" is used for identification of the 3' adaptor sequence for the reverse reads. Partial alignments to these sequences are tolerated. Sequence reads shorter than 5 bp after trimming are removed. Reads with N's are allowed to be retained.
### Input files:
Quality-filtered sequence reads in FASTQ format for individual samples, as shown below. Detailed instructions on file preparation can be found in the section titled "Set up directories and prepare files". Please note that "GroupID" and "SampleID" within the path below are placeholders and should be replaced accordingly. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.fastq 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.fastq 
### Output files:
Sequence reads after adaptor trimming in FASTQ format.
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.3clipped.fq 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.3clipped.fq 
### Command: 
Trim the 3' adaptor sequences from forward reads 
- sbatch submit_03_3clip.sh 
Trim the 3' adaptor sequences from reverse reads 
- sbatch submit_03_3clip_read2.sh
## Step 4: Enumerate sequence reads after trimming 3' adaptors
### Description:
This step involves enumerating the sequence reads after trimming 3' adaptors. The counts for forward and reverse reads may not be identical at this point. 
### Input files:
Sequence reads after adaptor trimming in FASTQ format. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.3clipped.fq
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.3clipped.fq 
### Output files:
A tabulate summary of the sequence read counts after trimming 3' adaptors. 
- _3_3clippedcount_formatted.txt 
### Command: 
sbatch submit_04a_3clipcount.sh 
## Generate the reverse complement (RC) of the reverse reads
### Description:
This step involves converting reverse reads to their reverse complement, which facilitates the downstream processing. 
### Input files:
Sequence reads after adaptor trimming in FASTQ format. 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.3clipped.fq 
### Output files:
RC of the reverse reads after adaptor trimming in FASTQ format. 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.rc3clipped.fq 
### Command: 
sbatch submit_05a_rcread2.sh
## Step 6: Trim the random nucleotides from Linker 1 for forward and reverse reads
### Description:
This step involves trimming the two random nucleotides originated from the 5' of Linker 1. During library preparation, these two random nucleotides effectively mitigate ligation biases induced by diverse terminal sequences of the RNA molecules. These random nucleotides are not trimmed with the 3' adaptors and thus need to be trimmed in this step.
### Input files:
Forward reads and RC reverse reads after adaptor trimming. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.3clipped.fq 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.rc3clipped.fq 
### Output files:
Forward reads and RC reverse reads after random nucleotide trimming.
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.3clipped.fq_trimNN 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.rc3clipped.fq_trimNN 
### Command:
sbatch submit_06a_trimNN.sh
## Step 7: Filter sequence reads based on read length threshold of 10 bp
### Description:
This step restricts the downstream analyses to forward and RC reverse reads longer than 10 bp after random nucleotide trimming, as small RNA fragments and truncated cDNAs due to polymerase fall-off are unlikely to fall below 10 bp in length. 
### Input files:
Forward and RC reverse reads after random nucleotide trimming.
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.3clipped.fq_trimNN 
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.rc3clipped.fq_trimNN 
### Output files:
Forward and RC reverse reads after length filtering in FASTA format. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.10bp.fa  
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.10bp.fa
### Command:
Filter by length for forward reads.
- sbatch submit_07a_len10_read1.sh
Filter by length for RC reverse reads.
sbatch submit_07a_len10_read2.sh
## Step 8: BLAST analysis
### Description:
This step aligns the sequence reads after length filtering to the reference sequence library using blastn. The word size is set to 9 to bolster sensitivity. Output is generated in tabulate format to facilitate downstream analyses.
### Input files:
Forward and RC reverse reads after length filtering in FASTA format. 
- fastq/GroupID_SampleID/GroupID_SampleID_1_sequence.10bp.fa  
- fastq/GroupID_SampleID/GroupID_SampleID_2_sequence.10bp.fa 
### Output files:
Raw BLAST alignment results for forward and RC reverse reads in tabulate format 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblast
- tRNA_08-10_blast/GroupID_SampleID_2.tRNAblast
### Commands: 
Load the BLAST program. 
- module load blast/2.6.0 
Create the BLAST database from the reference sequence library in FASTA format. 
- makeblastdb -in StdOlg_Sequence.fasta -parse_seqids -dbtype nucl 
Create a directory for storing BLAST alignment results. 
- mkdir tRNA_08-10_blast 
Align forward reads to the reference sequence library. 
- sbatch submit_08_tRNAblast_read1.sh 
Align RC reverse reads to the reference sequence library. 
- sbatch submit_08_tRNAblast_read2.sh
## Step 9: Pair the forward and RC reverse reads that are successfully aligned to the reference sequence library
### Description:
This step cross-validates the BLAST alignment results by identifying pairs of forward and RC reverse reads that are aligned to the same reference sequence with an overlap between the aligned regions. 
### Input files:
Raw BLAST alignment results for forward and RC reverse reads in tabulate format. 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblast 
- tRNA_08-10_blast/GroupID_SampleID_2.tRNAblast 
### Output files:
Forward and RC reverse read pairs with a consensus alignment. 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblast_paired 
- tRNA_08-10_blast/GroupID_SampleID_2.tRNAblast_paired 
### Commands: 
sbatch submit_09_tRNAblastpair.sh
## Step 10: Enumerate sequences aligned to the reference sequence library. 
### Description:
This step involves enumerating unique forward and RC reverse reads that are successfully aligned to the reference sequence library. 
### Input files:
Raw BLAST alignment results for forward and RC reverse reads in tabulate format. 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblast 
- tRNA_08-10_blast/GroupID_SampleID_2.tRNAblast 
### Output files:
The count of unique forward and RC reverse reads that are successfully aligned to the reference sequence library. 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblastcount 
- tRNA_08-10_blast/GroupID_SampleID_2.tRNAblastcount 
### Commands: 
sbatch submit_10a_tRNAblastcount.sh
## Step 11: Resolve sequence reads aligned to multiple reference sequences 
### Description:
In cases where a single query sequence (i.e., sequence read) is successfully aligned to multiple subject sequences (i.e., reference sequences) during the BLAST analysis, this step aims to identify the optimal alignment based on various parameters, such as E-value, bit-score, and alignment length. Alignments demonstrating lower E-values, higher bit-scores, and/or longer lengths are considered superior compared to other alignment candidates. 
### Input files:
Forward and RC reverse read pairs with a consensus alignment. 
- tRNA_08-10_blast/GroupID_SampleID_1.tRNAblast_paired: read pairs with a consensus alignment 
### Output files: 
The optimal BLAST alignment for all sequence reads. 
- tRNA_11_culledfileout/SampleID_culled.txt
The optimal BLAST alignments for sequence reads that could not be aligned to unique reference sequences. 
- tRNA_11_culledfileout/SampleID_culled_disc.txt 
The optimal BLAST alignment for sequence reads with unique alignment to the reference sequence. library.
- tRNA_11_culledfileout/SampleID_culled_nodupe.txt 
### Commands: 
Create a directory for storing the optimal BLAST alignment files. 
- mkdir tRNA_11_culledfileout 
Identify the optimal BLAST alignments for sequence reads. 
- sbatch submit_11a_tRNAcull.sh 
## Step 12: Extract BLAST alignment results for each reference sequence. 
### Description:
This step partitions the BLAST alignment results with respect to individual reference sequences. 
### Input files:
The optimal BLAST alignment for sequence reads with unique alignment to the reference sequence. 
- tRNA_11_culledfileout/SampleID_culled_nodupe.txt 
### Output files:
The BLAST alignment results that belong to each reference sequence (e.g., specific tRNA isoacceptors). 
- tRNA_12_grepped/SampleID_Small-RNA-ID_maxeVal 
### Commands: 
Create a directory for storing output files. 
- mkdir tRNA_12_grepped 
Extract BLAST alignment results that belong to each reference sequence. 
- sbatch submit_12a_nodupe_tRNA.sh 
Remove BLAST alignments with eVal > 0.001. 
- sbatch submit_13a_recull_eVal_tRNA.sh 
## Step 13: Generate the abundance matrix. 
### Description:
This steps generates an abundance matrix, with members of the small RNA species of interest as rows and samples as columns, which can be used for downstream analyses. 
### Input files:
The BLAST alignment results that belong to each reference sequence (e.g., specific tRNA isoacceptors). 
- tRNA_12_grepped/SampleID_Small-RNA-ID_maxeVal 
### Output files: Abundance matrices based on the counts of full-length reads only or all reads. 
- tRNA_counts/FLcount_bytRNA_eValculled.txt 
- tRNA_counts/ALLcount_bytRNA_eValculled.txt 
### Commands: 
Create a directory for storing intermediate output files. 
- mkdir tRNA_13_tempcounts 
Enumerate full-length and partial alignments for each reference sequence. 
- sbatch submit_13b_count_tRNAalignments.sh 
Create a directory for storing abundance matrices. 
- mkdir tRNA_counts 
Reorganize intermediate results into abundance matrices to facilitate downstream analyses. 
- sbatch submit_13e_formatCounts_tRNA.sh 



