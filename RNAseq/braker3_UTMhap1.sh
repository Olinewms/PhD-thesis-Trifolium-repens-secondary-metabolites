# This script is for generating generating UTM_hap1 reference annotations in GFF3 format. 

#!/usr/bin/env bash
#SBATCH --job-name=BRAKER3
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --mem=200GB
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=140:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc
conda activate /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/braker

cd /home/newol210/macknight_oliver/braker_working_dir/hisat2_output_UTMhap1
/home/newol210/GeneMark-ETP/tools/samtools merge -o merged_bam_braker3.bam c2_S58.sorted.bam c4_S59.sorted.bam H1_S56.sorted.bam H2_S57.sorted.bam L1_S54.sorted.bam L3_S55.sorted.bam N1_S52.sorted.bam N3_S53.sorted.bam

cd /home/newol210/macknight_oliver/braker_working_dir/

GENOME_DIR="/home/newol210/macknight_oliver/braker_working_dir/"
BAMS_DIR="/home/newol210/macknight_oliver/braker_working_dir/minimap2_output_UTMhap1/"

braker.pl --species=TrifoliumRepens --genome="${GENOME_DIR}UTM_Trep_v1.0_hap1_genomic.fa" --rnaseq_sets_ids=c2_S58.sorted.bam,c4_S59.sorted.bam,H1_S56.sorted.bam,H2_S57.sorted.bam,L1_S54.sorted.bam,L3_S55.sorted.bam,N1_S52.sorted.bam,N3_S53.sorted.bam --rnaseq_sets_dirs="${BAMS_DIR}" --AUGUSTUS_SCRIPTS_PATH=/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/braker/bin/ --GENEMARK_PATH=/home/newol210/GeneMark-ETP/bin/gmes/ --SRATOOLS_PATH=/home/newol210/macknight_oliver/sratoolkit.3.1.1-ubuntu64/bin/ --HISAT2_PATH=/home/newol210/GeneMark-ETP/tools/
braker.pl --species=TrifoliumRepens --genome="${GENOME_DIR}UTM_Trep_v1.0_hap1_genomic.fa" --bam="${BAMS_DIR}Trinity_deNovo_minimap2_against_UTMhap1.sorted.bam" --gff3 --threads 128 --AUGUSTUS_SCRIPTS_PATH=/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/mamba_envs/braker/bin/ --GENEMARK_PATH=~/GeneMark-ETP/bin/gmes/

conda deactivate
