# This will remove the first line of the FeatureCounts output .txt file, then clean the column names of the second line to just include the sample names rather than the full file address
# It also removes the "_Aligned.sortedByCoord.out.bam" and "_Aligned.sortedByCoord.out_sorted.bam" from the sample names

sed '1d' featurecounts_output.txt | \
awk 'NR==1{
  for(i=7;i<=NF;i++){
    sub(/^.*\//, "", $i);                                           # remove path
    sub(/_Aligned\.sortedByCoord\.out(_sorted)?\.bam$/, "", $i);    # remove either suffix
  }
}
{print}' > featurecounts_output_cleaned.txt


# Step 2: Remove last 17 columns (this can be modified so you only keep the sample columns you want)
awk '{
  keep = NF - 17;
  for(i=1;i<=keep;i++) printf "%s%s",$i,(i<keep?OFS:ORS);
}' OFS="\t" featurecounts_output_cleaned.txt > featurecounts_output_cleaned_trimmed.txt



# For example, below would retain only the last 15 samples
awk '{
  start = NF - 14;                              # first of the last 15 columns
  for(i=1;i<=6;i++) printf "%s\t", $i;          # print metadata columns
  for(i=start;i<=NF;i++) printf "%s%s", $i, (i<NF?OFS:ORS);  # print last 15 samples
}' OFS="\t" featurecounts_output_cleaned.txt > featurecounts_last15.txt



# This can be used to remove the Chr, Start, End and Strand columns from a FeatureCounts output
# This was used with the T. pratense mapping results
awk '{
  printf "%s", $1;                              # keep column 1
  for (i=6; i<=NF; i++) printf "\t%s", $i;      # keep columns 6+
  print "";                        # newline
}' featurecounts.txt > featurecounts_removed.txt


# This can be used to append 'product' description onto DEGs with LOC gene_IDs
awk '
# Step 1: Read GTF and build mapping
FNR==NR {
    match($0, /gene_id "([^"]+)"/, g)
    match($0, /product "([^"]+)"/, p)
    if (g[1] && p[1]) prod[g[1]]=p[1]
    next
}

# Step 2: Process EdgeR file
NR==1 {print $0 "\tproduct"; next}   # add header
{
    gene=$1
    print $0 "\t" (gene in prod ? prod[gene] : "NA")
}' RefSeq_T_pratense.gtf significant_genes_FeatureCounts_10_samples_T_pratense_counts.txt > edger_with_product.txt



