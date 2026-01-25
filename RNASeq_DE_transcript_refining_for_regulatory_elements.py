import pandas as pd

# Load the CSV file into a dataframe
df = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/salmon_output/salmon_count_matrices/EdgeR_results/table_with_counts_unique_to_low_vs_high_attempt1_annotated.csv")

# List of keywords to filter for regulatory elements
keywords = [
    "MYB", "bHLH", "WRKY", "NAC", "AP2", "bZIP", "GRAS", "MADS-box", "HB", "HSF", 
    "Kinase", "phosphatase", "receptor", "MAPK", "F-box", 
    "Histone", "chromatin", "SWI/SNF", "methyltransferase", "demethylase", 
    "regulator", "repressor", "activator", "transcription", "factor", "bridge", "transporter", "NDR", "LRR" 
]

# Filter the dataframe by checking if any keyword appears in the 'salltitles' column
filtered_df = df[df['salltitles'].str.contains('|'.join(keywords), case=False, na=False)]

# Save the filtered dataframe to a new CSV file
filtered_df.to_csv("table_with_counts_unique_to_low_vs_high_attempt1_annotated_filtered_regulatory_elements.csv", index=False)

print(f"Filtered dataframe saved as 'table_with_counts_unique_to_low_vs_high_attempt1_annotated_filtered_regulatory_elements.csv' with {len(filtered_df)} transcripts.")
