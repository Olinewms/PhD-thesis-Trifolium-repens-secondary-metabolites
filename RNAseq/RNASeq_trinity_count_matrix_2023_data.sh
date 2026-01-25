#!/usr/bin/env bash
#SBATCH --job-name=trinity_GeneCount_matrix_2023_data
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=1:00:00

set -ueo pipefail

## Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/trinity/ 

cd /home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome

# Define the base directory containing all subdirectories
BASE_DIR="/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/RSEM_sample_specific_outputs/"

# Find all RSEM.genes.results files in the subdirectories and join them with a space
ISOFORMS_RESULTS_FILES="
${BASE_DIR}RSEM_sample_1_using_6SampleTranscriptome/RSEM_S1.isoforms.results
${BASE_DIR}RSEM_sample_2_using_6SampleTranscriptome/RSEM_S2.isoforms.results
${BASE_DIR}RSEM_sample_3_using_6SampleTranscriptome/RSEM_S3.isoforms.results
${BASE_DIR}RSEM_sample_4_using_6SampleTranscriptome/RSEM_S4.isoforms.results
${BASE_DIR}RSEM_sample_5_using_6SampleTranscriptome/RSEM_S5.isoforms.results
${BASE_DIR}RSEM_sample_6_using_6SampleTranscriptome/RSEM_S6.isoforms.results
${BASE_DIR}RSEM_sample_7_using_6SampleTranscriptome/RSEM_S7.isoforms.results
${BASE_DIR}RSEM_sample_8_using_6SampleTranscriptome/RSEM_S8.isoforms.results
${BASE_DIR}RSEM_sample_9_using_6SampleTranscriptome/RSEM_S9.isoforms.results
${BASE_DIR}RSEM_sample_10_using_6SampleTranscriptome/RSEM_S10.isoforms.results
"

# Define the path to abundance_estimates_to_matrix.pl
ABUNDANCE_SCRIPT="/home/newol210/macknight_oliver/mamba_envs/trinity/bin/abundance_estimates_to_matrix.pl"

# Define the gene-transcript map
GENE_TRANS_MAP="/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/Trinity.fasta.gene_trans_map"

# Run the command
$ABUNDANCE_SCRIPT --est_method RSEM --gene_trans_map $GENE_TRANS_MAP --name_sample_by_basedir $ISOFORMS_RESULTS_FILES

mamba deactivate
