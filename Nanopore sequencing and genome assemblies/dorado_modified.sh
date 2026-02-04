#!/usr/bin/env bash

#SBATCH --job-name=dorado_basecall_5_Trepens
#SBATCH --account=newol210
#SBATCH --partition=aoraki_gpu_A100_40GB
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --mem-per-gpu=64GB
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=72:00:00

# Purge pre-existing modules
module purge

# Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

# Run nvidia-smi to check GPU status
nvidia-smi

# Run dorado basecaller script
/projects/health_sciences/bms/biochemistry/macknight_lab/dorado_basecaller_modified.sh
