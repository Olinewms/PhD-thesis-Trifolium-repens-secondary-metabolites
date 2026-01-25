from Bio import SeqIO
import pandas as pd

# This script is for extracting the sequence (from a reference genome) that a variant is residing in 
# Load variants CSV
variants = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide/filtered_variants.csv", sep="\t", header=0)

# Load the reference genome into a dictionary
ref_genome = SeqIO.to_dict(SeqIO.parse("/home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna", "fasta"))

# Output FASTA file
output_fasta = "extracted_variant_regions_407.fasta"

# Open the output FASTA file for writing
with open(output_fasta, "w") as fasta_out:
    for _, row in variants.iterrows():
        chrom = row["CHROM"]
        pos = int(row["POS"])
        
        # Define start and end for a 300bp region centered on the variant
        start = max(0, pos - 150)  # Ensure start is not negative
        end = pos + 150

        # Extract sequence if chromosome exists in the reference
        if chrom in ref_genome:
            seq = ref_genome[chrom].seq[start:end]  # Extract sequence
            
            # Write to FASTA file
            fasta_out.write(f">{chrom}_{start}_to_{end}\n{seq}\n")

print(f"Sequences extracted and saved to {output_fasta}")
