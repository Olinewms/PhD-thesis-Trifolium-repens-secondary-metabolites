#!/usr/bin/env bash

#SBATCH --job-name=Rl_bedMethyl_table_construction_Dorado
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=8:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /home/newol210/macknight_oliver/pod5_oliver_clover_all/Rl_reMethylation_analysis

source ~/.bashrc

REFERENCE_PATH="/home/newol210/macknight_oliver/flye_output_post_porechop/Rl_dorado_porechopped_assembly/"
BASECALLS_PATH="/home/newol210/macknight_oliver/pod5_oliver_clover_all/Rl_reMethylation_analysis/"
MODBAM2BED_PATH="/home/newol210/macknight_oliver/modbam2bed/"
MODKIT_PATH="/home/newol210/macknight_oliver/dist_modkit_v0.4.1_cec0a0b/"

../../../dorado-0.8.0-linux-x64/bin/dorado aligner \
  ${REFERENCE_PATH}assembly_Rl.fasta \
  ${BASECALLS_PATH}Rl_guppy_5mC_merged.bam \
  > Rl_reanalysis_merged_aligned_mod.bam
  
samtools sort -o Rl_reanalysis_merged_aligned_mod.sorted.bam Rl_reanalysis_merged_aligned_mod.bam
samtools index Rl_reanalysis_merged_aligned_mod.sorted.bam

# Option 1:
${MODKIT_PATH}modkit pileup \
  Rl_reanalysis_merged_aligned_mod.sorted.bam \
  Rl_reanalysis_merged_aligned_mod_methylation.bed

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/htslib/
sort -k1,1 -k2,2n Rl_reanalysis_merged_aligned_mod_methylation.bed | bgzip -c > Rl_reanalysis_merged_aligned_mod_methylation.bed.gz && tabix -p bed Rl_reanalysis_merged_aligned_mod_methylation.bed.gz
mamba deactivate

echo "Finished Option 1"

#Option 2:
${MODKIT_PATH}modkit pileup \
   --bedgraph Rl_reanalysis_merged_aligned_mod.sorted.bam \
   Rl_reanalysis_merged_aligned_mod_methylation.bedgraph

for f in Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/*.bedgraph; do
    sort -k1,1 -k2,2n "$f" > "${f%.bedgraph}.sorted.bedgraph"
done

cut -f1-4 Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/h_negative.sorted.bedgraph > h_negative.4col.bedgraph
cut -f1-4 Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/h_positive.sorted.bedgraph > h_positive.4col.bedgraph
cut -f1-4 Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/m_negative.sorted.bedgraph > m_negative.4col.bedgraph
cut -f1-4 Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/m_positive.sorted.bedgraph > m_positive.4col.bedgraph

cut -f1,2 ${REFERENCE_PATH}assembly_Rl.fasta.fai > genome.sizes

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/ucsc_bedgraphtobigwig/ 

bedGraphToBigWig h_negative.4col.bedgraph genome.sizes Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/h_negative.bw
bedGraphToBigWig h_positive.4col.bedgraph genome.sizes Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/h_positive.bw
bedGraphToBigWig m_negative.4col.bedgraph genome.sizes Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/m_negative.bw
bedGraphToBigWig m_positive.4col.bedgraph genome.sizes Rl_reanalysis_merged_aligned_mod_methylation.bedgraph/m_positive.bw

mamba deactivate

echo "Finished"
