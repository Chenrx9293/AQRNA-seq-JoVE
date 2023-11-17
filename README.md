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
