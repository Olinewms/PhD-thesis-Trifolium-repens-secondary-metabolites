#!/bin/bash
#SBATCH --job-name=freebayes
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=50:00:00
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err

set -ueo pipefail

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/freebayes

#cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams

# First you need to add a sample tag to each .bam file that you want to use, and then re-index them
#samtools addreplacerg -r ID:H1 -r SM:H1 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/H1.rg.bam H1_S56_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:H2 -r SM:H2 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/H2.rg.bam H2_S57_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:H4 -r SM:H4 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/H4.rg.bam H4_S66_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:H5 -r SM:H5 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/H5.rg.bam H5_S67_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:H6 -r SM:H6 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/H6.rg.bam H6_S68_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:L1 -r SM:L1 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/L1.rg.bam L1_S54_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:L3 -r SM:L3 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/L3.rg.bam L3_S55_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:L4 -r SM:L4 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/L4.rg.bam L4_S63_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:L5 -r SM:L5 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/L5.rg.bam L5_S64_Aligned.sortedByCoord.out_sorted.bam
#samtools addreplacerg -r ID:L6 -r SM:L6 -o variants_LowVsHigh_genomeWide_freebayes_tetraploid/L6.rg.bam L6_S65_Aligned.sortedByCoord.out_sorted.bam

#cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/

#samtools index H1.rg.bam
#samtools index H2.rg.bam
#samtools index H4.rg.bam
#samtools index H5.rg.bam
#samtools index H6.rg.bam
#samtools index L1.rg.bam
#samtools index L3.rg.bam
#samtools index L4.rg.bam
#samtools index L5.rg.bam
#samtools index L6.rg.bam

# Running Freebayes
#freebayes -f /home/newol210/macknight_oliver/braker_working_dir/UTM_Trep_v1.0_hap1_genomic.fa \
#--ploidy 4 \
#-L bam_list_fastpReads_UTMhap1.list \
#--region CM061880.1 \
#--min-alternate-count 2 \
#--min-alternate-fraction 0.2 \
#--use-best-n-alleles 5 \
#-v freebayes_tetraploid_low_vs_high_CM061880.vcf

#mamba deactivate

### After doing the variant calling, proceed to filtering etc:
mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools
cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/freebayes_tetraploid_low_vs_high_CM061880/

# Rename the headers for ease-of-use downstream
#bcftools reheader -s sample_map.txt -o variants_renamedSamples.vcf freebayes_tetraploid_low_vs_high_CM061887.vcf

# Sort and index vcf file
bgzip -c freebayes_tetraploid_low_vs_high_CM061880.vcf > variants_renamedSamples.vcf.gz
bcftools sort variants_renamedSamples.vcf.gz -o variants_renamedSamples_sorted.vcf 
bgzip -c variants_renamedSamples_sorted.vcf > variants_renamedSamples_sorted.vcf.gz
bcftools index variants_renamedSamples_sorted.vcf.gz

# Low-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o low_specific_variants.vcf
#bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]~"^0/0/0/0$")=COUNT(GT[@samplesLow.txt])' variants_renamedSamples_sorted.vcf.gz -o low_specific.vcf
#bcftools view -i'COUNT(GT[@samplesHigh.txt]!~"1")=0 & COUNT(GT[@samplesLow.txt]!="0/0/0/0")=0' variants_renamedSamples_sorted.vcf.gz -o bcftools_view_low_specific_variants.vcf

# High-pigment-specific variants
#bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]!="0/0")=0' variants_renamedSamples_sorted.vcf.gz -o high_specific_variants.vcf
#bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]~"^0/0/0/0$")=COUNT(GT[@samplesHigh.txt])' variants_renamedSamples_sorted.vcf.gz -o high_specific.vcf
#bcftools view -i'COUNT(GT[@samplesLow.txt]!~"1")=0 & COUNT(GT[@samplesHigh.txt]!="0/0/0/0")=0' variants_renamedSamples_sorted.vcf.gz -o bcftools_view_high_specific_variants.vcf

# This can be used to check that filtered vcf's actually contain variants:
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' bcftools_view_low_specific_variants.vcf | head -n 30
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' bcftools_view_high_specific_variants.vcf | head -n 30

# Then you can use the following to get all the 
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' bcftools_view_low_specific_variants.vcf | awk -F"\t" '{print $1 "\t" $2}' > chromosome_and_positions_coseg_vars_NoneVsHigh.txt
#bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' bcftools_view_high_specific_variants.vcf | awk -F"\t" '{print $1 "\t" $2}' >> chromosome_and_positions_coseg_vars_NoneVsHigh.txt

#mamba deactivate
