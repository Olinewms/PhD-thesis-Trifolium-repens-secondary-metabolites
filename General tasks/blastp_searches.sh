# This script is for conducting protein searches via blastp

#!/usr/bin/env bash
#SBATCH --job-name=blastp_search
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=5GB
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=7:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /home/newol210/macknight_oliver/bcftools_csq_working_dir

blastp -query filtered_proteins.fasta -db /home/newol210/macknight_oliver/blastp_database_refseq/refseq_protein -out filtered_proteins_blastpRefSeq.txt -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore salltitles" -num_threads 64
