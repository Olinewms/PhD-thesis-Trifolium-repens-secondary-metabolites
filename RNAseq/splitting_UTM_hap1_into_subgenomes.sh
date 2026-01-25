#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

# List all chromosome names
GENOME_DIR="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/braker_working_dir/"
seqkit seq -n ${GENOME_DIR}/UTM_Trep_v1.0_hap1_genomic.fa


cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes

# Make a text file with the TrTo chromosome names
echo -e "CM061879.1\nCM061881.1\nCM061883.1\nCM061885.1\nCM061887.1\nCM061889.1\nCM061891.1\nCM061893.1" > UTM_hap1_chr_set1_TrTo.txt

# Make a text file with the TrTp chromosome names
echo -e "CM061880.1\nCM061882.1\nCM061884.1\nCM061886.1\nCM061888.1\nCM061890.1\nCM061892.1\nCM061894.1" > UTM_hap1_chr_set2_TrTp.txt

# Extract chromosomes into two files
seqkit grep -f UTM_hap1_chr_set1_TrTo.txt ${GENOME_DIR}/UTM_Trep_v1.0_hap1_genomic.fa > UTM_hap1_chr_set1_TrTo.fasta

seqkit grep -f UTM_hap1_chr_set2_TrTp.txt ${GENOME_DIR}/UTM_Trep_v1.0_hap1_genomic.fa > UTM_hap1_chr_set2_TrTp.fasta


echo "Finished"