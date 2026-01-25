# Use this code when you have a GTF file that has gene product descriptions associtated with a LOC ID, and you want to append the gene product onto the respective DEGs.

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
}' file.gtf edger_output.txt > edger_with_product.tx
