#!/bin/bash
#SBATCH --job-name=bcftools_variant_calling
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=100:00:00
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err

set -ueo pipefail

source ~/.bashrc

mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools/

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams
bcftools mpileup -f /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -b ./bam_list_fastpReads_UTMhap1.list | bcftools call -mv -Ov -o variants.vcf

# Rename the headers for ease-of-use downstream
bcftools reheader -s sample_map.txt -o variants_renamedSamples.vcf variants.vcf

# Sort and index vcf file
bgzip -c variants_renamedSamples.vcf > variants_renamedSamples.vcf.gz
bcftools sort variants_renamedSamples.vcf.gz -o variants_renamedSamples_sorted.vcf 
bgzip -c variants_renamedSamples_sorted.vcf > variants_renamedSamples_sorted.vcf.gz
bcftools index variants_renamedSamples_sorted.vcf.gz

# Low-pigment-specific variants
bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o low_specific_variants.vcf

# High-pigment-specific variants
bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o high_specific_variants.vcf

# This can be used to check that filtered vcf's actually contain variants:
bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' low_specific_variants.vcf | head -n 30
bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' high_specific_variants.vcf | head -n 30

conda deactivate
