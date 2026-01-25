import pandas as pd

df = pd.read_table('/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/salmon_output/salmon_count_matrices/EdgeR_results/filtered_unique_DE_in_LowVsHigh_blastnOut_regulatory_elements.tsv')
with open('candidate_regions.bed', 'w') as bed_file:
    for _, row in df.iterrows():
        start = min(row['sstart'], row['send'])
        end = max(row['sstart'], row['send'])
        bed_file.write(f"{row['sseqid']}\t{start-1}\t{end}\n")  # BED uses 0-based indexing
