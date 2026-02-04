#!/usr/bin/env bash

#SBATCH --job-name=RepeatModeler
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=60GB
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --mail-user=newol210@student.otago.ac.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --time=72:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc

mamba activate /home/newol210/macknight_oliver/mamba_envs/repeatmodeler
cd /home/newol210/macknight_oliver/braker_working_dir

# Create a Database for RepeatModeler
BuildDatabase -name Trepens_UTMhap1_repeat.db UTM_Trep_v1.0_hap1_genomic.fa 

# Run RepeatModeler
RepeatModeler -database Trepens_UTMhap1_repeat.db -threads 64

mamba deactivate
