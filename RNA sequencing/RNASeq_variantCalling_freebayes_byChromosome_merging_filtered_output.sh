#!/bin/bash
#SBATCH --job-name=vcf_to_csv
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=20GB
#SBATCH --time=5:00:00
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err

set -ueo pipefail

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/freebayes_output

# List of chromosomes
CHROMS=(
CM061879.1
CM061880.1
CM061881.1
CM061882.1
CM061883.1
CM061884.1
CM061885.1
CM061886.1
CM061887.1
CM061888.1
CM061889.1
CM061890.1
CM061891.1
CM061892.1
CM061893.1
CM061894.1
)

# Output file for combined CHROM + POS
COMBINED_OUTPUT="low_and_high_coseg_vars_freebayes_tetraploid_pysamFiltered.txt"

# Clear the combined output file if it exists
> "$COMBINED_OUTPUT"

for CHR in "${CHROMS[@]}"; do
    echo "Processing chromosome $CHR..."

    # Generate CSV files from VCFs
    bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' low_specific_variants_${CHR}.vcf > low_specific_variants_${CHR}.csv
    bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' high_specific_variants_${CHR}.vcf > high_specific_variants_${CHR}.csv

    # Extract CHROM and POS, and append to the combined file
    awk -F"\t" '{print $1 "\t" $2}' low_specific_variants_${CHR}.csv >> "$COMBINED_OUTPUT"
    awk -F"\t" '{print $1 "\t" $2}' high_specific_variants_${CHR}.csv >> "$COMBINED_OUTPUT"
done

mamba deactivate
