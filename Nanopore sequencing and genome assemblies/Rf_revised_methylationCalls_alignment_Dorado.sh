#!/usr/bin/env bash

#SBATCH --job-name=Rf_bedMethyl_table_construction_Dorado
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=5:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /home/newol210/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging/

source ~/.bashrc

REFERENCE_PATH="/home/newol210/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging/flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly/"
BASECALLS_PATH="/home/newol210/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging/"
MODBAM2BED_PATH="/home/newol210/macknight_oliver/modbam2bed/"
MODKIT_PATH="/home/newol210/macknight_oliver/dist_modkit_v0.4.1_cec0a0b/"

../../../dorado-0.8.0-linux-x64/bin/dorado aligner \
  ${REFERENCE_PATH}Rf_revised_assembly.fasta \
  ${BASECALLS_PATH}Rf_revised_merged.bam \
  > Rf_revised_merged_aligned_mod.bam
  
samtools sort -o Rf_revised_merged_aligned_mod_sorted.bam Rf_revised_merged_aligned_mod.bam
samtools index Rf_revised_merged_aligned_mod_sorted.bam

# Option 1:
${MODKIT_PATH}modkit pileup \
  Rf_revised_merged_aligned_mod_sorted.bam \
  Rf_revised_merged_aligned_mod_methylation.bed

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/htslib/
sort -k1,1 -k2,2n Rf_revised_merged_aligned_mod_methylation.bed | bgzip -c > Rf_revised_merged_aligned_mod_methylation_sorted.bed.gz && tabix -p bed Rf_revised_merged_aligned_mod_methylation_sorted.bed.gz
mamba deactivate

#Option 2:
${MODKIT_PATH}modkit pileup \
   --bedgraph Rf_revised_merged_aligned_mod_sorted.bam \
   Rf_revised_merged_aligned_mod_methylation.bedgraph

for f in Rf_revised_merged_aligned_mod_methylation.bedgraph/*.bedgraph; do
    sort -k1,1 -k2,2n "$f" > "${f%.bedgraph}.sorted.bedgraph"
done

cut -f1-4 Rf_revised_merged_aligned_mod_methylation.bedgraph/h_negative.sorted.bedgraph > h_negative.4col.bedgraph
cut -f1-4 Rf_revised_merged_aligned_mod_methylation.bedgraph/h_positive.sorted.bedgraph > h_positive.4col.bedgraph
cut -f1-4 Rf_revised_merged_aligned_mod_methylation.bedgraph/m_negative.sorted.bedgraph > m_negative.4col.bedgraph
cut -f1-4 Rf_revised_merged_aligned_mod_methylation.bedgraph/m_positive.sorted.bedgraph > m_positive.4col.bedgraph

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/ucsc_bedgraphtobigwig/ 

bedGraphToBigWig Rf_revised_merged_aligned_mod_methylation.bedgraph/h_negative.4col.bedgraph genome.sizes Rf_revised_merged_aligned_mod_methylation.bedgraph/h_negative.bw
bedGraphToBigWig Rf_revised_merged_aligned_mod_methylation.bedgraph/h_positive.4col.bedgraph genome.sizes Rf_revised_merged_aligned_mod_methylation.bedgraph/h_positive.bw
bedGraphToBigWig Rf_revised_merged_aligned_mod_methylation.bedgraph/m_negative.4col.bedgraph genome.sizes Rf_revised_merged_aligned_mod_methylation.bedgraph/m_negative.bw
bedGraphToBigWig Rf_revised_merged_aligned_mod_methylation.bedgraph/m_positive.4col.bedgraph genome.sizes Rf_revised_merged_aligned_mod_methylation.bedgraph/m_positive.bw

mamba deactivate

echo "Finished"
