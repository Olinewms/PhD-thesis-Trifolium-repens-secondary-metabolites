import gzip
import pysam
from pyfaidx import Fasta
from collections import defaultdict

# This script is for extracting genes within a particular region of the UTM_Trep_v1.0_hap1 T. repens reference genome. I used this to extract the genes that were in variant-rich regions (variants between low- and high-pigment plants). 
# Input files
gtf_file = "/home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/stringtie_UTM_Trep_v1_hap1_merged.sorted.gtf.gz"
fasta_file = "/home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/ncbi_dataset/data/GCA_030914245.1/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna"
output_fasta = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide/genes_in_region_CM061887_39000kb_49000kb.fasta"

# Define region of interest
chrom = "CM061887.1"
start = 39000000  # 39,000 kb
end = 49000000    # 49,000 kb

def extract_exon_coordinates(gtf_file, chrom, start, end):
    """Extract exon coordinates for each gene from the GTF file within the specified region."""
    gene_exons = defaultdict(list)
    with gzip.open(gtf_file, 'rt') as gtf:
        for line in gtf:
            if line.startswith("#"):
                continue
            fields = line.strip().split('\t')
            if fields[2] != "exon":  # Use exon features instead of transcript
                continue
            gtf_chrom, gtf_start, gtf_end = fields[0], int(fields[3]), int(fields[4])
            if gtf_chrom == chrom and gtf_start <= end and gtf_end >= start:
                # Extract gene ID from attributes
                attributes = fields[8]
                gene_id = None
                for attr in attributes.split("; "):
                    if attr.startswith("gene_id"):
                        gene_id = attr.split(" ")[1].strip('"')
                        break
                if gene_id:
                    gene_exons[gene_id].append((gtf_start, gtf_end))
    return gene_exons

def extract_exon_sequences(fasta_file, gene_exons, output_fasta):
    """Extract exon sequences from the reference genome and save to a FASTA file."""
    fasta = Fasta(fasta_file)
    with open(output_fasta, "w") as out_fasta:
        for gene_id, exons in gene_exons.items():
            exons.sort()  # Ensure exons are ordered by position
            sequence = "".join([fasta[chrom][start-1:end].seq for start, end in exons])
            out_fasta.write(f">{gene_id}\n{sequence}\n")

# Run the pipeline
gene_exons = extract_exon_coordinates(gtf_file, chrom, start, end)
extract_exon_sequences(fasta_file, gene_exons, output_fasta)
print(f"Extracted {len(gene_exons)} genes (exons only). Sequences saved in {output_fasta}.")
