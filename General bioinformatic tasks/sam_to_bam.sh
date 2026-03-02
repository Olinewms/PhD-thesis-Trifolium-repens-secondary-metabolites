#!/usr/bin/env bash

#SBATCH --job-name=sam2bam
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log)
#SBATCH --error=slurm_%j.err
#SBATCH --time=78:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate samtools
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs/

samtools view -bS greenFlyePorechopped_hisat2_output.sam | samtools sort -o greenFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RfFlyePorechopped_hisat2_output.sam | samtools sort -o RfFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RldFlyePorechopped_hisat2_output.sam | samtools sort -o RldFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RlFlyePorechopped_hisat2_output.sam | samtools sort -o RlFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RmFlyePorechopped_hisat2_output.sam | samtools sort -o RmFlyePorechopped_hisat2_output_sorted.bam | samtools index -

conda deactivate

echo "Finished"

