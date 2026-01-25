import pandas as pd

# Load variants CSV
variants = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/variants_LowVsHigh_genomeWide/filtered_variants.csv", sep="\t", header=0)
variants.columns = ["chrom", "pos"] + [f"sample_{i}" for i in range(variants.shape[1] - 2)]  # Naming extra columns dynamically

# Load DEGs TSV
degs = pd.read_csv("/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/gene_and_isoformCountsMatrices_rsem/filtered_unique_DE_to_LowVsHigh_rsem_isoformCounts_blastnOut_UTMhap1_ref.tsv", sep="\t", header=0)
degs.columns = ["qseqid", "chrom", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore", "salltitles"]

# Convert position columns to integers
degs["sstart"] = degs["sstart"].astype(int)
degs["send"] = degs["send"].astype(int)

# Initialize list for filtered variants
filtered_variants = []

# Iterate through each variant
for _, var in variants.iterrows():
    var_chrom = var["chrom"]
    var_pos = int(var["pos"])
    
    # Check if the variant is within 7000 bp of any DEG
    for _, deg in degs.iterrows():
        if var_chrom == deg["chrom"]:
            if abs(var_pos - deg["sstart"]) <= 7000 or abs(var_pos - deg["send"]) <= 7000:
                filtered_variants.append(var.tolist())
                break  # No need to check further if already matched

# Convert to DataFrame and save filtered variants
filtered_variants_df = pd.DataFrame(filtered_variants, columns=variants.columns)
filtered_variants_df.to_csv("filtered_variants_near_DEGs.csv", sep="\t", index=False)

print(f"Filtering complete! {len(filtered_variants_df)} variants remain.")
