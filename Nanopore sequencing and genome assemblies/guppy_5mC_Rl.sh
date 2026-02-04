#!/usr/bin/env bash

#SBATCH --job-name=guppy_5mC_Rl
#SBATCH --account=newol210
#SBATCH --partition=aoraki_gpu_A100_40GB
#SBATCH --ntasks-per-node=1 
#SBATCH --gres=gpu:2
#SBATCH --mem-per-gpu=64GB
#SBATCH --cpus-per-task=32t
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=165:00:00

# Purge pre-existing modules
module purge

# Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

# Run nvidia-smi to check GPU status
nvidia-smi

#!/bin/bash

source ~/.bashrc
conda activate minimap2

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Rl_5mC_guppy_basecalling/

../ont-guppy/bin/guppy_basecaller --input_path ./input_fast5_data/ --save_path ./guppy_basecalling/ --config ../ont-guppy/data/res_dna_r941_min_modbases-all-context_v001.cfg --align_ref ../flye_output_post_porechop/Rl_dorado_porechopped_assembly/assembly_Rl_fasta.idx --bam_out --num_callers 128

conda deactivate
