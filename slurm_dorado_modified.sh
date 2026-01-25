#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=dorado_basecall_5_Trepens
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki_gpu_A100_40GB
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Number of GPUs 
#SBATCH --gres=gpu:1
#
# Memory per GPU
#SBATCH --mem-per-gpu=64GB
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
#SBATCH --time=72:00:00

# Commands go below

## Purge pre-existing modules
module purge

## Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

## Run nvidia-smi to check GPU status
#nvidia-smi

# Run dorado basecaller script
/projects/health_sciences/bms/biochemistry/macknight_lab/dorado_basecaller_modified.sh