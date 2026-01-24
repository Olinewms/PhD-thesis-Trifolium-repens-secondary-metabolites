# This script is for consensus calling, to determine which variants cosegregating with low- and high-pigment phenotypes cause amino-acid changes in the protein-coding sequences they reside in.

#!/usr/bin/env bash
#SBATCH --job-name=bcftools_csq
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --mem=100GB
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=48:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools

cd /home/newol210/macknight_oliver/bcftools_csq_working_dir

GENOME_DIR="/home/newol210/macknight_oliver/braker_working_dir/"
GFF3_DIR="/home/newol210/macknight_oliver/braker_working_dir/braker/"
VARS_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide/"

bcftools csq -f "${GENOME_DIR}UTM_Trep_v1.0_hap1_genomic.fa" -g "${GFF3_DIR}braker.gff3" "${VARS_DIR}low_specific_variants.vcf" --phase a --threads 128 -Ob -o out.bcf
bcftools view out.bcf -Ov -o out.vcf
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/BCSQ\n' out.vcf > annotated_variants_low_specific.tsv

mamba deactivate
