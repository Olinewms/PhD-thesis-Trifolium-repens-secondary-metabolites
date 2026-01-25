import pandas as pd

# This script takes a bidirectional filtering approach, rather than RNASeq_filtering_coseg_vars.py that just retains immediate neighbours
# Load the CSV file
df = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_inc_2023_Highs/cosegregating_variants_low_vs_high_inc2023_highs.csv", sep="\t", header=0)

# Ensure sorting by chromosome and position
df.sort_values(by=["CHROM", "POS"], inplace=True)

# Group by chromosome
filtered_variants = []

for chrom, group in df.groupby("CHROM"):
    positions = group["POS"].tolist()
    
    # Store indices of variants that have at least one neighbor within 5000 bp
    keep_indices = set()
    
    # Check distances between variants
    for i in range(len(positions)):
        for j in range(i + 1, len(positions)):
            if positions[j] - positions[i] > 5000:
                break  # No need to check further if out of range
            keep_indices.add(i)
            keep_indices.add(j)

    # Add retained variants
    for idx in keep_indices:
        filtered_variants.append(group.iloc[idx].tolist())

# Convert back to DataFrame
filtered_df = pd.DataFrame(filtered_variants, columns=df.columns)

# Save filtered variants
filtered_df.to_csv("filtered_variants_new.csv", sep="\t", index=False)

print(f"Filtering complete! {len(filtered_df)} variants retained.")
