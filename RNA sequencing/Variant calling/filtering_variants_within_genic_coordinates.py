import pandas as pd

# Load the variant list and genomic location table
variant_file = "CM061887.1_coseg_variants_POS.tsv"
location_file = "filtered_genes_in_region_CM061887_39000kb_49000kb_blastnOut_UTMhap1_sstart_send.tsv"

# Read the variant list into a Pandas Series
variants = pd.read_csv(variant_file, header=None, names=["variant"])

# Read the genomic location table into a DataFrame
locations = pd.read_csv(location_file, sep="\t")

# Filter the variants to keep those that fall within any of the ranges
filtered_variants = variants[variants["variant"].apply(
    lambda x: any((x >= start and x <= end) for start, end in zip(locations['sstart'], locations['send']))
)]

# Output the filtered variants
filtered_variants.to_csv("filtered_variants.tsv", header=False, index=False)
print(filtered_variants)
