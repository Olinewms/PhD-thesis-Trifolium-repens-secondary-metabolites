#!/usr/bin/env bash

#SBATCH --job-name=Rld_bedMethyl_table_construction_Dorado
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

cd /home/newol210/macknight_oliver/pod5_oliver_clover_all/Rld_reMethylation_analysis

source ~/.bashrc

REFERENCE_PATH="/home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/"
BASECALLS_PATH="/home/newol210/macknight_oliver/pod5_oliver_clover_all/Rld_reMethylation_analysis/"
MODBAM2BED_PATH="/home/newol210/macknight_oliver/modbam2bed/"
MODKIT_PATH="/home/newol210/macknight_oliver/dist_modkit_v0.4.1_cec0a0b/"

../../../dorado-0.8.0-linux-x64/bin/dorado aligner \
  ${REFERENCE_PATH}GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna \
  ${BASECALLS_PATH}basecalls_Rld_pod5_2024_barcoded.bam \
  > Rld_reanalysis_merged_aligned_mod_UTM1.bam
  
samtools sort -o Rld_reanalysis_merged_aligned_mod_UTM1.sorted.bam Rld_reanalysis_merged_aligned_mod_UTM1.bam
samtools index Rld_reanalysis_merged_aligned_mod_UTM1.sorted.bam

# Option 1:
${MODKIT_PATH}modkit pileup \
  Rld_reanalysis_merged_aligned_mod_UTM1.sorted.bam \
  Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bed

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/htslib/
sort -k1,1 -k2,2n Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bed | bgzip -c > Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bed.gz && tabix -p bed Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bed.gz
mamba deactivate

echo "Finished Option 1"

#Option 2:
${MODKIT_PATH}modkit pileup \
   --bedgraph Rld_reanalysis_merged_aligned_mod_UTM1.sorted.bam \
   Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph

for f in Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/*.bedgraph; do
    sort -k1,1 -k2,2n "$f" > "${f%.bedgraph}.sorted.bedgraph"
done

cut -f1-4 Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_negative.sorted.bedgraph > Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_negative.4col.bedgraph
cut -f1-4 Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_positive.sorted.bedgraph > Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_positive.4col.bedgraph
cut -f1-4 Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_negative.sorted.bedgraph > Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_negative.4col.bedgraph
cut -f1-4 Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_positive.sorted.bedgraph > Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_positive.4col.bedgraph

cut -f1,2 ${REFERENCE_PATH}GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna.fai > genome_UTM1.sizes

mamba activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/ucsc_bedgraphtobigwig/ 

bedGraphToBigWig Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_negative.4col.bedgraph genome_UTM1.sizes Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_negative.bw
bedGraphToBigWig Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_positive.4col.bedgraph genome_UTM1.sizes Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/h_positive.bw
bedGraphToBigWig Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_negative.4col.bedgraph genome_UTM1.sizes Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_negative.bw
bedGraphToBigWig Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_positive.4col.bedgraph genome_UTM1.sizes Rld_reanalysis_merged_aligned_mod_UTM1_methylation.bedgraph/m_positive.bw

mamba deactivate

echo "Finished"
