#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Porechop/

porechop -i ../Porechop_input_files/basecalls_Green_pod5_2023.fastq -o basecalls_Green_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/basecalls_Rl_pod5_2023.fastq -o basecalls_Rl_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged.fastq -o Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.fastq -o Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.fastq -o Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64

echo "Finished Porechopping all dorado Fastq files"