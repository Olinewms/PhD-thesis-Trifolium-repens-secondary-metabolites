# This code will modify the second document so that its order of rows, from top to bottom, match the order of transcript IDs in the first document.
# E.g., file1.txt can be significant_genes_none_vs_high_fastpProcessed_2023_data_only.txt
# and file2.txt can be significant_genes_none_vs_high_fastpProcessed_2023_data_only_blastnOut_core_nt_filtered.tsv

awk 'NR==FNR {order[FNR]=$1; next} {data[$1]=$0} END {for (i=1; i<=FNR; i++) print data[order[i]]}' sig_DE_file.txt blastnOut_core_nt_filtered.txt > file2_reordered.txt

# The you can use the following to append the 13th column of the reordered BLASTn results to the DEGs with eggNOG annotations 
# Here, file3.txt was significant_genes_none_vs_high_fastpProcessed_2023_data_only_w_eggNOG_annotations.txt
# Note that 'paste' doesn't seem to work while using fish

paste file3.txt <(cut -f13 file2_reordered.txt) > file3_appended.txt
