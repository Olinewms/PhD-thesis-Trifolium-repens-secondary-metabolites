#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=bedMethyl_table_construction
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki
#
# Ensure the allocation only goes on a single node
#SBATCH --nodes=1
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Memory per GPU
#SBATCH --mem=200GB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=64
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
#SBATCH --time=78:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/pod5_oliver_clover_all/

# 
source ~/.bashrc
conda activate minimap2

samtools fastq -T '*' basecalls_Rf_pod5_2024_barcoded.bam | minimap2 -x map-ont -a -t 64 -y --secondary=no ../flye_output_post_porechop/Rf_dorado_porechopped_assembly/assembly.fasta - > ../minimap2_output/Rf_mapped_to_RfFlyeAssembly.bam
samtools fastq -T '*' basecalls_Rld_pod5_2024_barcoded.bam | minimap2 -x map-ont -a -t 64 -y --secondary=no ../flye_output_post_porechop/Rld_dorado_porechopped_assembly/assembly.fasta - > ../minimap2_output/Rld_mapped_to_RldFlyeAssembly.bam
samtools fastq -T '*' basecalls_Rm_pod5_2024_barcoded.bam | minimap2 -x map-ont -a -t 64 -y --secondary=no ../flye_output_post_porechop/Rm_dorado_porechopped_assembly/assembly.fasta - > ../minimap2_output/Rm_mapped_to_RmFlyeAssembly.bam

conda deactivate

# Sort all dorado basecalled bam files
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/minimap2_output/
SAMPLES="Rf_mapped_to_RfFlyeAssembly Rld_mapped_to_RldFlyeAssembly Rm_mapped_to_RmFlyeAssembly"
for SAMPLE in $SAMPLES; do
    samtools sort ${SAMPLE}.bam > ${SAMPLE}_sorted.bam
done

# Index all sorted dorado basecalled bam files
SAMPLES="Rf_mapped_to_RfFlyeAssembly_sorted Rld_mapped_to_RldFlyeAssembly_sorted Rm_mapped_to_RmFlyeAssembly_sorted"
for SAMPLE in $SAMPLES; do
    samtools index ${SAMPLE}.bam ${SAMPLE}.bam.bai
done

../modbam2bed/modbam2bed ../flye_output_post_porechop/Rf_dorado_porechopped_assembly/assembly.fasta Rf_mapped_to_RfFlyeAssembly_sorted.bam > Rf_mapped_to_RfFlyeAssembly.bed
../modbam2bed/modbam2bed ../flye_output_post_porechop/Rld_dorado_porechopped_assembly/assembly.fasta Rld_mapped_to_RldFlyeAssembly_sorted.bam > Rld_mapped_to_RldFlyeAssembly.bed
../modbam2bed/modbam2bed ../flye_output_post_porechop/Rm_dorado_porechopped_assembly/assembly.fasta Rm_mapped_to_RmFlyeAssembly_sorted.bam > Rm_mapped_to_RmFlyeAssembly.bed

conda activate bedtools
SAMPLES="Rf_mapped_to_RfFlyeAssembly Rld_mapped_to_RldFlyeAssembly Rm_mapped_to_RmFlyeAssembly"
for SAMPLE in $SAMPLES; do
    bedtools sort -i ${SAMPLE}.bed > ${SAMPLE}_sorted.bed
done

# Make a bedMethyl table for each sortec bam file
#SAMPLES="basecalls_Rf_pod5_2024_barcoded_sorted basecalls_Rld_pod5_2024_barcoded_sorted basecalls_Rl_pod5_2023_sorted basecalls_Rm_pod5_2024_barcoded_sorted"
#for SAMPLE in $SAMPLES; do
#    modkit pileup ${SAMPLE}.bam  --force-allow-implicit /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/modkit_pileups_doradoBAMS/${SAMPLE}_pileup.bed --log-filepath /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/modkit_pileups_doradoBAMS/pileup.log
#done

echo "Finished"