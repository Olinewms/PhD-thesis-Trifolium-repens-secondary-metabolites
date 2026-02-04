#!/usr/bin/env bash

#SBATCH --job-name=htslib
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=128
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=24:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate htslib
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs/

sort -k1,1 -k4,4n greenFlyePorechopped_hisat2_output.gtf > greenFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RfFlyePorechopped_hisat2_output.gtf > RfFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RldFlyePorechopped_hisat2_output.gtf > RldFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RlFlyePorechopped_hisat2_output.gtf > RlFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RmFlyePorechopped_hisat2_output.gtf > RmFlyePorechopped_hisat2_output.sorted.gtf


SAMPLES="greenFlyePorechopped_hisat2_output.sorted RfFlyePorechopped_hisat2_output.sorted RldFlyePorechopped_hisat2_output.sorted RlFlyePorechopped_hisat2_output.sorted RmFlyePorechopped_hisat2_output.sorted"
for SAMPLE in $SAMPLES; do
    bgzip ${SAMPLE}.gtf
    tabix -p gff {SAMPLE}.gtf.gz
done

conda deactivate

echo "Finished"
