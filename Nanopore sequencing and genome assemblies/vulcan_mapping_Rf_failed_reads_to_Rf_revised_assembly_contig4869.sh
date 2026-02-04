#!/usr/bin/env bash

#SBATCH --job-name=vulcan_Rf_contig
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=600GB
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=1:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc

mamba activate /home/newol210/macknight_oliver/mamba_envs/vulcan
cd /home/newol210/macknight_oliver/pod5_oliver_clover_all/clover_8sampleMulti_12082024_NB26_failed_fastcalled_fastqs

#vulcan -i PAW22381_fail_barcode26_ab990672_8d5c9775_merged.fasta -r ../../pod5_oliver_clover_all/bams_Rf_revised_merging/flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly/contig_4869.fasta -o PAW22381_fail_barcode26_ab990672_8d5c9775_against_contig4869.bam -w vulcan_output -t 32 -ont
vulcan -i ../bams_Rf_revised_merging/Rf_revised_merged.fasta -r ../../pod5_oliver_clover_all/bams_Rf_revised_merging/flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly/contig_4869.fasta -o Rf_revised_merged.fasta_against_contig4869.bam -w vulcan_output_2 -t 32 -ont

mamba deactivate

samtools sort Rf_revised_merged.fasta_against_contig4869.bam_90.bam  > Rf_revised_merged.fasta_against_contig4869_against_contig4869_sorted.bam
samtools index Rf_revised_merged.fasta_against_contig4869_against_contig4869_sorted.bam
