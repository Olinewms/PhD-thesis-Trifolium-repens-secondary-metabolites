#!/bin/bash
#SBATCH --job-name=process_vcfs
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=20:00:00
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err

set -ueo pipefail

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/bcftools

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/freebayes_output/

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

for CHR in "${CHROMS[@]}"; do
    echo "Processing $CHR..."

    # Compress and sort VCF
    bgzip -c freebayes_tetraploid_${CHR}.vcf > freebayes_tetraploid_${CHR}.vcf.gz
    bcftools sort freebayes_tetraploid_${CHR}.vcf.gz -o freebayes_tetraploid_${CHR}_sorted.vcf
    bgzip -c freebayes_tetraploid_${CHR}_sorted.vcf > freebayes_tetraploid_low_vs_high_${CHR}_sorted.vcf.gz
    bcftools index freebayes_tetraploid_low_vs_high_${CHR}_sorted.vcf.gz

    # Run variant filtering
    python /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/filter_polyploid_variants_pysam.py \
      -i freebayes_tetraploid_low_vs_high_${CHR}_sorted.vcf.gz \
      -l samplesLow.txt \
      -s samplesHigh.txt \
      -H high_specific_variants_${CHR}.vcf \
      -L low_specific_variants_${CHR}.vcf
done

mamba deactivate
