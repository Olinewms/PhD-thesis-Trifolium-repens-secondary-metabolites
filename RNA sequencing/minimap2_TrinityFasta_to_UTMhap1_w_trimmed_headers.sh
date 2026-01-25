#!/usr/bin/env bash

#SBATCH --job-name=minimap2_trinity
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=1:00:00

#!/bin/bash

# This script is mapping my de novo transcriptome assembly to the UTMhap1 reference genome with the cleaned headers

# Stop script if there is an error
set -ueo pipefail

#!/bin/bash

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/minimap2

# Define input and output paths
# Set the reference genome FASTA file (or a pre-built .mmi index if available)
REF_GENOME="/home/newol210/macknight_oliver/braker_working_dir/UTM_Trep_v1.0_hap1_genomic.fa"
OUTPUT_DIR="/home/newol210/macknight_oliver/braker_working_dir/minimap2_output_UTMhap1"
INPUT_FASTA="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples/Trinity.fasta"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define output filenames
SAMPLE_NAME="Trinity"
SAM_OUTPUT="$OUTPUT_DIR/${SAMPLE_NAME}_minimap2_output.sam"
BAM_OUTPUT="$OUTPUT_DIR/${SAMPLE_NAME}_deNovo_minimap2_against_UTMhap1.sorted.bam"

# Run minimap2 in splice mode
 -ax splice : spliced alignment mode (good for RNA/transcript sequences)
 -uf       : indicates that the query sequences are full-length cDNA (assembled transcripts)
 -k14      : sets the k-mer size to 14 (adjustable depending on your data)
minimap2 -ax splice -uf -k14 "$REF_GENOME" "$INPUT_FASTA" > "$SAM_OUTPUT"

# Convert SAM to BAM, sort, and index with samtools
/home/newol210/GeneMark-ETP/tools/samtools view -bS "$SAM_OUTPUT" | /home/newol210/GeneMark-ETP/tools/samtools sort -o "$BAM_OUTPUT" -
/home/newol210/GeneMark-ETP/tools/samtools index "$BAM_OUTPUT"

# Optional: Remove the intermediate SAM file to save space
rm "$SAM_OUTPUT"

mamba deactivate


# This gives details on the alignment:
samtools flagstat Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam

# These pull out all unaligned reads/ transcripts:
# -F 256 gives only the primary unmappped transcripts (in this case, the following output .bam files were identical)
samtools view -b -f 4 -F 256 Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam > primary_unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam
samtools view -b -f 4 Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam > unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam

# This gives the unaligned reads/ transcripts in fasta format:
samtools fasta primary_unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam > primary_unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.fasta

# Then run a blastn search on this fasta and reformat/ filter it
# Then remove rows that contain "N/A", "virus", "homo", "Rattus", "human", "synthetic", "antigen", "bacterium" or "strain" etc in the salltitles column
awk -F'\t' 'tolower($13) !~ /n\/a|virus|homo|rattus|human|synthetic|antigen|bacterium|strain|phage|frankliniella|conidiobolus/' filtered_primary_unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.fasta_blastnOut_core_nt.tsv > filtered2_primary_unmapped_transcripts_Trinity_deNovo_minimap2_against_UTMhap1.sorted.fasta_blastnOut_core_nt_.tsv





