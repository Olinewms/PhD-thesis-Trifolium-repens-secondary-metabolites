#!/usr/bin/env bash

#SBATCH --job-name=trinity_align_and_estimate
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=24:00:00

#!/bin/bash

# Stop script if there is an error (note: this doesn't work with an rsem conda environment)
set -ueo pipefail

# Allow conda environments to be called
source ~/.bashrc

conda activate rsem

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/

# Directory containing the RNA-Seq fastq files
FASTQ_DIR="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs"

# Path to the Trinity transcriptome FASTA
TRANSCRIPTOME="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples/Trinity.fasta"

# Path to the align_and_estimate_abundance.pl script
ALIGN_SCRIPT="/home/newol210/miniconda3/envs/trinity/bin/align_and_estimate_abundance.pl"

# This command is here because for some reason, sample N1 wasn't working (uncomplete output)
${ALIGN_SCRIPT} --transcripts ${TRANSCRIPTOME} --seqType fq --left N1_S52_R1_fastp.fastq.gz --right N1_S52_R2_fastp.fastq.gz --est_method RSEM --aln_method bowtie2 --trinity_mode --debug --prep_reference --output_dir RSEM_N1_S52_using_8SampleTranscriptome_2

# Loop through all R1 fastq files in the directory
for R1_FILE in ${FASTQ_DIR}/*_R1_fastp.fastq.gz; do
  # Extract SAMPLE_ID by removing the directory and file extensions
  BASENAME=$(basename ${R1_FILE})
  SAMPLE_ID=${BASENAME%_R1_fastp.fastq.gz}
  
  # Define corresponding R2 file
  R2_FILE="${FASTQ_DIR}/${SAMPLE_ID}_R2_fastp.fastq.gz"
  
  # Define output directory
  OUTPUT_DIR="salmon_${SAMPLE_ID}_using_8SampleTranscriptome"
  
  # Run the align_and_estimate_abundance.pl command
  CMD="${ALIGN_SCRIPT} --transcripts ${TRANSCRIPTOME} --seqType fq --left ${R1_FILE} --right ${R2_FILE} --est_method salmon --trinity_mode --prep_reference --output_dir ${OUTPUT_DIR}"
  
  # Print and execute the command
  echo "Running command for SAMPLE_ID: ${SAMPLE_ID}"
  echo "${CMD}"
  eval ${CMD}
done

conda deactivate
