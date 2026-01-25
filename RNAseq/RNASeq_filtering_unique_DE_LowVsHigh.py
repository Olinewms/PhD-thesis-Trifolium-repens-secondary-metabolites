import pandas as pd

# Load the two tables
none_vs_high = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/EdgeR_rsem_de_novo_SIG_DE_isoforms_None_vs_High_test1.csv")
low_vs_high = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/EdgeR_rsem_de_novo_SIG_DE_isoforms_Low_vs_High_test1.csv")

# Find the transcripts in 'low_vs_high' that are NOT in 'none_vs_high'
unique_low_vs_high = low_vs_high[~low_vs_high['Transcript'].isin(none_vs_high['Transcript'])]

# Save the result to a new CSV file
unique_low_vs_high.to_csv("unique_DE_in_LowVsHigh.csv", index=False)

print("Transcripts unique to LowVsHigh have been written to 'unique_DE_to_LowVsHigh_rsem.csv'.")
