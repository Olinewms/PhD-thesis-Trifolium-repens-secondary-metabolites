#!/bin/bash
#SBATCH --job-name=freebayes
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
mamba activate /home/newol210/macknight_oliver/mamba_envs/freebayes
cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_freebayes_tetraploid/

# Reference genome
REF="/home/newol210/macknight_oliver/braker_working_dir/UTM_Trep_v1.0_hap1_genomic.fa"
BAMS="bam_list_fastpReads_UTMhap1.list"

# List of chromosomes to process
CHROMS=(
CM061889.1
CM061890.1
CM061891.1
CM061892.1
CM061893.1
CM061894.1
)

# Output directory (optional)
OUTDIR="freebayes_output_rd2"
mkdir -p "$OUTDIR"

# Run Freebayes for each chromosome
for CHR in "${CHROMS[@]}"; do
    echo "Running Freebayes on $CHR..."
    freebayes -f "$REF" \
      --ploidy 4 \
      -L "$BAMS" \
      --region "$CHR" \
      --min-alternate-count 2 \
      --min-alternate-fraction 0.2 \
      --use-best-n-alleles 5 \
      -v "$OUTDIR/freebayes_tetraploid_${CHR}.vcf"
done

mamba deactivate
