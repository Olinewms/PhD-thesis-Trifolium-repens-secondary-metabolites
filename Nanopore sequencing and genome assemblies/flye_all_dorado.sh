#!/usr/bin/env bash

#SBATCH --job-name=flye_dorado_basecalled_5_Trepens
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1TB
#SBATCH --cpus-per-task=126t
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=168:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/porechop_output

# Make green assembly
~/miniconda3/bin/flye --nano-hq basecalls_Green_pod5_2023_porechopped.fastq.gz -o ../flye_output/green_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished green assembly"

# Make Rf assembly
~/miniconda3/bin/flye --nano-hq Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged_porechopped.fastq.gz -o ../flye_output/Rf_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished Rf assembly"

# Make Rm assembly
~/miniconda3/bin/flye --nano-hq Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz -o ../flye_output/Rm_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished Rm assembly"

# Make Rld assembly
~/miniconda3/bin/flye --nano-hq Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz -o ../flye_output/Rld_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished Rld assembly"

# Make Rl assembly
~/miniconda3/bin/flye --nano-hq basecalls_Rl_pod5_2023_porechopped.fastq.gz -o ../flye_output/Rl_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished all assemblies"
