#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=vulcan
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki_gpu_A100_80GB
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Number of GPUs 
#SBATCH --gres=gpu:1
#
# Memory per GPU
#SBATCH --mem-per-gpu=80GB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=32
#
# File to save stdout output
#SBATCH --output=slurm_%j.log
#
# File to save stderr (Error logfile)
#SBATCH --error=slurm_%j.err
#
# Email
#SBATCH --mail-user=newol210@student.otago.ac.nz
#SBATCH --mail-type=END,FAIL
#
# Time required to run job (hh:mm:ss)
#SBATCH --time=100:00:00

# Commands go below

## Purge pre-existing modules
module purge

## Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

## Run nvidia-smi to check GPU status
#nvidia-smi

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc
#conda activate vulcan

cd /home/newol210/macknight_oliver/vulcan_mapping_longreads_to_UTMhap1

#vulcan -i ../porechop_input_files/basecalls_Rl_pod5_2023.fastq.gz  -r ../reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -o basecalls_Rl_pod5_2023_mapped_UTMhap1.bam -w vulcan_output -t 32 -ont
#vulcan -i ../porechop_input_files/Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged.fastq.gz  -r ../reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -o Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_mapped_UTMhap1.bam -w vulcan_output -t 32 -ont
#vulcan -i ../porechop_input_files/Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz  -r ../reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -o Rld_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1.bam -w vulcan_output -t 32 -ont
#vulcan -i ../porechop_input_files/Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz  -r ../reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -o Rm_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1.bam -w vulcan_output -t 32 -ont

#conda deactivate
conda activate samtools

samtools sort basecalls_Rl_pod5_2023_mapped_UTMhap1.bam  > basecalls_Rl_pod5_2023_mapped_UTMhap1_sorted.bam
samtools sort Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_mapped_UTMhap1.bam > Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_mapped_UTMhap1_sorted.bam
samtools sort Rld_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1.bam > Rld_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1_sorted.bam
samtools sort Rm_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1.bam > Rm_whole_genome_seq_SUP_5mC_5hmC_mapped_UTMhap1_sorted.bam

conda deactivate

