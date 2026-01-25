import pandas as pd

# File paths
#table_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/EdgeR_rsem_de_novo_SIG_DE_isoforms_Low_vs_High_test1.csv"  # File with Trinity IDs in the first column
#count_matrix_file = "/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/rsem_outputs/RSEM.isoform.counts.LowVsHigh.matrix.txt"  # Count matrix file
#output_file = "table_with_counts_low_vs_high_rsem.csv"  # Output file

table_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_ISOFORMS_RSEM_10_samples_6sampleDeNovo.csv"
count_matrix_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/RSEM.isoform.counts.matrix"
output_file = "/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_ISOFORMS_RSEM_10_samples_6sampleDeNovo_raw_counts_appended.csv"

# Load the table with Trinity IDs
table_df = pd.read_csv(table_file)

# Load the count matrix file (tab-delimited)
count_matrix_df = pd.read_csv(count_matrix_file, sep="\t")

# Merge the table with the count matrix using the Trinity IDs in the first column
merged_df = table_df.merge(count_matrix_df, how="left", left_on=table_df.columns[0], right_on=count_matrix_df.columns[0])

# Save the merged table to a new CSV file
merged_df.to_csv(output_file, index=False)

print(f"Merged table with counts saved to {output_file}.")




