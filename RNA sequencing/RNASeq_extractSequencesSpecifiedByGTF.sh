#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=bedtools_GTF_extract
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki
#
# Ensure the allocation only goes on a single node
#SBATCH --nodes=1
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Memory per GPU
#SBATCH --mem=1TB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=64
#
# File to save stdout output
#SBATCH --output=slurm_%j.log
#
# File to save stderr (Error logfile)
#SBATCH --error=slurm_%j.err
#
# Email
#SBATCH --mail-user=newol210@student.otago.ac.nz
#SBATCH --mail-type=END,FAIL
#
# Time required to run job (hh:mm:ss)
#SBATCH --time=12:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc

conda activate bedtools

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/

# This command converts the .gtf file to a bed file (specifically pulling out "transcript" ID's) 
awk '$3 == "transcript" {print $1"\t"$4"\t"$5"\t"$9"\t.\t"$7}' stringtie_UTM_Trep_v1_hap1_merged.gtf > UTMhap1_1st_stringtie_genes_updated.bed

# Now use the bed file (with transcript ID's) to pull out sequences from the reference genome respective to each specified coordinate
bedtools getfasta -fi ../ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna -bed UTMhap1_1st_stringtie_genes_updated.bed -fo UTMhap1_1st_stringtie_genes_extracted_sequences_updated.fasta

conda deactivate

# Now we need to change the headers of the UTMhap1_1st_stringtie_genes_extracted_sequences.fasta from genomic coordinates to transcript ID's
awk -F '\t' '$3 == "transcript" {                                                                                                                                                                                       
                                                       match($9, /transcript_id "[^"]+"/); 
                                                       transcript_id = substr($9, RSTART+15, RLENGTH-16); 
                                                       print $1":"$4"-"$5, transcript_id
                                                   }' stringtie_UTM_Trep_v1_hap1_merged.gtf > mapping.txt
                                              
                                              
     
# updated_3_sequences.fasta should have transcript ID's as headers rather than the genomic locations
awk 'NR==FNR {map[$1] = $2; next} /^>/ {header = substr($0, 2); if (header in map) print ">" map[header]; else print $0} !/^>/' mapping.txt UTMhap1_1st_stringtie_genes_extracted_sequences_updated.fasta > updated_3_sequences.fasta

# Generate a Gene-to-Transcript Mapping File (create a mapping file that associates each transcript ID with its parent gene ID from the annotation.gtf file)
awk -F '\t' '$3 == "transcript" { 
    match($9, /gene_id "([^"]+)";/, gene_id); 
    match($9, /transcript_id "([^"]+)";/, transcript_id); 
    if (gene_id[1] && transcript_id[1]) 
        print gene_id[1], transcript_id[1]; 
}' stringtie_UTM_Trep_v1_hap1_merged.gtf > gene_transcript_map.txt


# Then run your python script that uses the gene_transcript_map.txt to change headers in updated_3_sequences.fasta from transcript IDs to their respective gene ID's
python ReplaceTranscriptIDsInUpdated_sequencesfastaHeadersWithCorrespondingGeneIDsBasedOnMap.py    

# Now you can go to your R script and use the python scripts output to find the significantly differentially-expressed sequences
