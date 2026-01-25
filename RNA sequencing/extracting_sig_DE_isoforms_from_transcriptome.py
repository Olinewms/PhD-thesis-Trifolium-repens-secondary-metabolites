from Bio import SeqIO

# File paths
input_fasta = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples/Trinity.fasta"
csv_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/revised_deNovo_RSEM_EdgeR_DE_analysis/significant_DEGs_low_vs_high_TrinityDeNovo_FDR_0.005.txt"
output_fasta = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/revised_deNovo_RSEM_EdgeR_DE_analysis/significant_DEGs_low_vs_high_TrinityDeNovo_FDR_0.005.fasta"

# Read gene IDs from the first column of the CSV file (in order)
gene_ids = []
with open(csv_file) as f:
    next(f)  # Skip header
    for line in f:
        gene_id = line.split("\t")[0].strip()
        gene_ids.append(gene_id)

# Extract sequences in the same order as gene_ids
records_dict = SeqIO.to_dict(SeqIO.parse(input_fasta, "fasta"))

# Write the sequences in order with cleaned headers
with open(output_fasta, "w") as out_fasta:
    for gene_id in gene_ids:
        if gene_id in records_dict:
            record = records_dict[gene_id]
            record.id = gene_id  # Keep only the gene ID
            record.description = ""  # Remove everything after the ID
            SeqIO.write(record, out_fasta, "fasta")

print(f"Extracted sequences in order with cleaned headers. Output written to {output_fasta}.")

