#!/usr/bin/env bash
#SBATCH --job-name=STAR_separate_subgenomes
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=24:00:00

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/star

# Clean the headers of the referenc genome being used (in this case it is the UTM_hap2 reference)
#awk '{if($0 ~ /^>/) {print $1} else {print $0}}' GCA_030914255.1_UTM_Trep_v1.0_hap2_genomic.fna > UTM_Trep_v1.0_hap2_cleaned_headers.fna

# Index the reference genomes
GENOME_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes"

STAR --runThreadN 64 \
     --runMode genomeGenerate \
     --genomeDir ${GENOME_DIR}/UTM_hap1_chr_set1_TrTo/ \
     --genomeFastaFiles ${GENOME_DIR}/UTM_hap1_chr_set1_TrTo/UTM_hap1_chr_set1_TrTo.fasta \
     --genomeSAindexNbases 13
    
STAR --runThreadN 64 \
     --runMode genomeGenerate \
     --genomeDir ${GENOME_DIR}/UTM_hap1_chr_set2_TrTp/ \
     --genomeFastaFiles ${GENOME_DIR}/UTM_hap1_chr_set2_TrTp/UTM_hap1_chr_set2_TrTp.fasta \
     --genomeSAindexNbases 13

mamba deactivate