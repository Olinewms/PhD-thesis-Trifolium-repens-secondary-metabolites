#!/bin/bash
#SBATCH --job-name=bcftools_variant_calling_separate_subgenomes
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

# First you need to index all your BAM files

#cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/output_STAR_2025_RNA_TrTo_mapping/TrTo_bams
#for bam in *_Aligned.sortedByCoord.out.bam; do
#    echo "Indexing $bam..."
#    samtools index "$bam"
#done

#cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/output_STAR_2025_RNA_TrTp_mapping/TrTp_bams
#for bam in *_Aligned.sortedByCoord.out.bam; do
#    echo "Indexing $bam..."
#    samtools index "$bam"
#done

mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools/

### mpileup and filtering for TrTo mapping
cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/output_STAR_2025_RNA_TrTo_mapping/TrTo_bams

GENOME_TrTo=/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/UTM_hap1_chr_set1_TrTo/UTM_hap1_chr_set1_TrTo.fasta

bcftools mpileup -f ${GENOME_TrTo} -b ./bam_list_fastpReads_UTMhap1_TrTo.list | bcftools call -mv -Ov -o variants_TrTo.vcf

# Rename the headers for ease-of-use downstream
bcftools reheader -s sample_map_TrTo.txt -o variants_renamedSamples.vcf variants_TrTo.vcf

# Sort and index vcf file
bgzip -c variants_renamedSamples.vcf > variants_renamedSamples.vcf.gz
bcftools sort variants_renamedSamples.vcf.gz -o variants_renamedSamples_sorted.vcf 
bgzip -c variants_renamedSamples_sorted.vcf > variants_renamedSamples_sorted.vcf.gz
bcftools index variants_renamedSamples_sorted.vcf.gz

# Low-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o low_specific_variants.vcf

# High-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o high_specific_variants.vcf

# This can be used to check that filtered vcf's actually contain variants:
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' low_specific_variants.vcf | head -n 30
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' high_specific_variants.vcf | head -n 30

echo "Finished TrTo variants"

### mpileup and filtering for TrTp mapping
cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/output_STAR_2025_RNA_TrTp_mapping/TrTp_bams

GENOME_TrTp=/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/UTM_hap1_chr_set2_TrTp/UTM_hap1_chr_set2_TrTp.fasta

bcftools mpileup -f ${GENOME_TrTp} -b ./bam_list_fastpReads_UTMhap1_TrTp.list | bcftools call -mv -Ov -o variants_TrTp.vcf

# Rename the headers for ease-of-use downstream
bcftools reheader -s sample_map_TrTp.txt -o variants_renamedSamples.vcf variants_TrTp.vcf

# Sort and index vcf file
bgzip -c variants_renamedSamples.vcf > variants_renamedSamples.vcf.gz
bcftools sort variants_renamedSamples.vcf.gz -o variants_renamedSamples_sorted.vcf 
bgzip -c variants_renamedSamples_sorted.vcf > variants_renamedSamples_sorted.vcf.gz
bcftools index variants_renamedSamples_sorted.vcf.gz

# Low-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o low_specific_variants.vcf

# High-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o high_specific_variants.vcf

# This can be used to check that filtered vcf's actually contain variants:
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' low_specific_variants.vcf | head -n 30
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' high_specific_variants.vcf | head -n 30

echo "Finished TrTp variants"

mamba deactivate
