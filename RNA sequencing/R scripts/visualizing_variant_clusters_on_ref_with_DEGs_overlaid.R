BiocManager::install("karyoploteR")

# Load necessary libraries
library(karyoploteR)
library(GenomicRanges)
library(readr)

# Read genome.txt (chromosome names and lengths)
genome_data <- read_delim("/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/UTM_hap1_ref_for_karyotypeR.txt", delim = "\t", col_names = FALSE)

# Rename columns for clarity
colnames(genome_data) <- c("chrom", "length")

# Convert to GRanges object
custom.genome <- GRanges(
  seqnames = genome_data$chrom,
  ranges = IRanges(start = 1, end = genome_data$length)
)

# Read variants (no headers, tab-delimited)
variants <- read_delim("/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/chromosome_and_positions_coseg_vars_NoneVsHigh.txt", delim = "\t", col_names = FALSE)
colnames(variants) <- c("chrom", "pos")
variant_positions <- toGRanges(data.frame(
  chr = variants$chrom,
  start = variants$pos,
  end = variants$pos
))

# Read differential expressed genes (DEG) file
de_genes <- read_delim("/home/newol210/macknight_oliver/2023_de_novo_6_sample_transcriptome/edgeR_and_blastn_outputs/significant_isoforms_none_vs_high_blastnOut_UTM_hap1_filtered_reordered_chr_POS.txt", delim = "\t", col_names = FALSE)
colnames(de_genes) <- c("chrom", "pos")
de_positions <- toGRanges(data.frame(
  chr = de_genes$chrom,
  start = de_genes$pos,
  end = de_genes$pos
))

# Plot karyotype using the custom genome
kp <- plotKaryotype(genome = custom.genome)

# Plot variant density
kpPlotDensity(kp, data = variant_positions, col = rgb(0, 0, 1, 0.5), border = "darkblue", window.size = 200000)

# Add base numbers
kpAddBaseNumbers(kp, tick.dist = 10000000)

# Optionally, plot individual variant and DEG points
#kpPoints(kp, data = de_positions, y = runif(length(de_positions), 0, 1), col = "red", cex = 0.4)
kpPoints(kp, data = de_positions, y = 0.5, col = "red", cex = 0.5)

