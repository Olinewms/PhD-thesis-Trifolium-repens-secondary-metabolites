#!/usr/bin/env bash

#SBATCH --job-name=hisatMapping_bulkRNA
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=78:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/flye_output_post_porechop/

source ~/.bashrc
conda activate hisat2

# HISAT2 reference indexing
hisat2-build ./green_dorado_porechopped_assembly/assembly.fasta ./green_dorado_porechopped_assembly/greenFlyePorechoppedHISAT2_indexed_genome
hisat2-build ./Rf_dorado_porechopped_assembly/assembly.fasta ./Rf_dorado_porechopped_assembly/RfFlyePorechoppedHISAT2_indexed_genome
hisat2-build ./Rld_dorado_porechopped_assembly/assembly.fasta ./Rld_dorado_porechopped_assembly/RldFlyePorechoppedHISAT2_indexed_genome
hisat2-build ./Rl_dorado_porechopped_assembly/assembly.fasta ./Rl_dorado_porechopped_assembly/RlFlyePorechoppedHISAT2_indexed_genome
hisat2-build ./Rm_dorado_porechopped_assembly/assembly.fasta ./Rm_dorado_porechopped_assembly/RmFlyePorechoppedHISAT2_indexed_genome

# HISAT2 mapping 
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs

hisat2 -x ../flye_output_post_porechop/green_dorado_porechopped_assembly/greenFlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S greenFlyePorechopped_hisat2_output.sam | samtools view -bS - | samtools sort -o greenFlyePorechopped_hisat2_output.sorted.bam - && samtools index greenFlyePorechopped_hisat2_output.sorted.bam
hisat2 -x ../flye_output_post_porechop/Rf_dorado_porechopped_assembly/RfFlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S RfFlyePorechopped_hisat2_output.sam | samtools view -bS - | samtools sort -o RfFlyePorechopped_hisat2_output.sorted.bam - && samtools index RfFlyePorechopped_hisat2_output.sorted.bam
hisat2 -x ../flye_output_post_porechop/Rld_dorado_porechopped_assembly/RldFlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S RldFlyePorechopped_hisat2_output.sam | samtools view -bS - | samtools sort -o RldFlyePorechopped_hisat2_output.sorted.bam - && samtools index RldFlyePorechopped_hisat2_output.sorted.bam
hisat2 -x ../flye_output_post_porechop/Rl_dorado_porechopped_assembly/RlFlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S RlFlyePorechopped_hisat2_output.sam | samtools view -bS - | samtools sort -o RlFlyePorechopped_hisat2_output.sorted.bam - && samtools index RlFlyePorechopped_hisat2_output.sorted.bam
hisat2 -x ../flye_output_post_porechop/Rm_dorado_porechopped_assembly/RmFlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S RmFlyePorechopped_hisat2_output.sam | samtools view -bS - | samtools sort -o RmFlyePorechopped_hisat2_output.sorted.bam - && samtools index RmFlyePorechopped_hisat2_output.sorted.bam

conda deactivate

# Then pipe hisat2_output.bam.bai to StringTie to make a GTF specific to each genome
# stringtie [-o <output.gtf>] [other_options] <read_alignments.bam> 

echo "Finished"
