from collections import defaultdict

#input_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/salmon_output/salmon_count_matrices/EdgeR_results/unique_DE_in_LowVsHigh_blastnOut_regulatory_elements.tsv"
#output_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/salmon_output/salmon_count_matrices/EdgeR_results/filtered_unique_DE_in_LowVsHigh_blastnOut_regulatory_elements.tsv"
#fasta_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/salmon_output/salmon_count_matrices/EdgeR_results/unique_DE_in_LowVsHigh_deNovo_EdgeR_test1_extracted_sequences_regulatory_elements.fasta"

input_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_isoforms_none_vs_high_blastnOut_UTM_hap1.tsv"
output_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_isoforms_none_vs_high_blastnOut_UTM_hap1_filtered.tsv"
fasta_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_ISOFORMS_none_vs_high_clean_headers.fasta"

# Dictionary to store the best hit for each query
best_hits = defaultdict(lambda: None)

# Step 1: Read and find the best hit (highest bit-score) for each query
with open(input_file) as f:
    for line in f:
        cols = line.strip().split("\t")
        qseqid, sseqid, pident, length, mismatch, gapopen, qstart, qend, sstart, send, evalue, bitscore, salltitles = cols
        bitscore = float(bitscore)
        if best_hits[qseqid] is None or bitscore > float(best_hits[qseqid][11]):
            best_hits[qseqid] = cols

# Step 2: Get query order from the original FASTA file
fasta_queries = []
with open(fasta_file) as f:
    for line in f:
        if line.startswith(">"):
            fasta_queries.append(line.strip().lstrip(">"))

# Step 3: Write the output in the same order as the FASTA file
with open(output_file, "w") as out:
    header = "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tsalltitles\n"
    out.write(header)
    for query in fasta_queries:
        if query in best_hits:
            out.write("\t".join(best_hits[query]) + "\n")
        else:
            out.write(f"{query}\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\n")
