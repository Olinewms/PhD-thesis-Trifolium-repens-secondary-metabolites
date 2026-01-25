import pandas as pd

# This script filters out variants that are not in proximity to 1 or more other coseg. variants. 
# Prior to running this, you need to manually merge low_specific_variants and high_specific_variants into a single .csv by running e.g. bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' low_specific_variants.vcf > low_specific_variants.csv on both vcf files

# Load the CSV file
df = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide_inc_2023_Highs/cosegregating_variants_low_vs_high_inc2023_highs.csv", sep="\t", header=None)

# Rename columns for clarity
df.columns = ["CHROM", "POS"] + [f"Sample{i}" for i in range(1, df.shape[1] - 1)]

# Ensure sorting by chromosome and position
df.sort_values(by=["CHROM", "POS"], inplace=True)

# Filtering variants that have at least one neighbor within 5000 bp
filtered_variants = []
prev_chrom, prev_pos = None, None

for i, row in df.iterrows():
    chrom, pos = row["CHROM"], row["POS"]

    # Check proximity within 5000 bp for the same chromosome
    if prev_chrom == chrom and (pos - prev_pos) <= 5000:
        filtered_variants.append(row.tolist())  # Keep this row
    elif i < len(df) - 1:  # Look ahead to the next variant
        next_pos = df.iloc[i + 1]["POS"]
        if chrom == df.iloc[i + 1]["CHROM"] and (next_pos - pos) <= 5000:
            filtered_variants.append(row.tolist())

    prev_chrom, prev_pos = chrom, pos  # Update last seen variant

# Convert back to DataFrame
filtered_df = pd.DataFrame(filtered_variants, columns=df.columns)

# Save filtered variants
filtered_df.to_csv("filtered_variants_inc_2023_Highs.csv", sep="\t", index=False)

print(f"Filtering complete! {len(filtered_df)} variants retained.")
