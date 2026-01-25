#!/usr/bin/env bash
#SBATCH --job-name=blastn_DEGs
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=5:00:00

#!/bin/bash

# Stop script if there is an error (note: this doesn't work with an rsem conda environment)
set -ueo pipefail

blastn \
    -query /home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_ISOFORMS_none_vs_high_clean_headers.fasta \
    -db /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/UTM_hap1_blastn_database/UTM_hap1_blast_db \
    -out /home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/significant_isoforms_none_vs_high_blastnOut_UTM_hap1.tsv \
    -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore salltitles" \
    -num_threads 64
