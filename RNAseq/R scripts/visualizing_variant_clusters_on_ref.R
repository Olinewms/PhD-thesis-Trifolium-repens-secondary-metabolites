BiocManager::install("karyoploteR")

# Load necessary libraries
library(karyoploteR)
library(GenomicRanges)
library(readr)

# Read genome.txt (chromosome names and lengths)
genome_data <- read_delim("UTM_hap1_ref_for_karyotypeR.txt", delim = "\t", col_names = FALSE)

# Rename columns for clarity
colnames(genome_data) <- c("chrom", "length")

# Convert to GRanges object
custom.genome <- GRanges(
  seqnames = genome_data$chrom,
  ranges = IRanges(start = 1, end = genome_data$length)
)

# Read variants (no headers, tab-delimited)
variants <- read_delim("chromosome_and_positions_coseg_vars_NoneVsHigh.txt", delim = "\t", col_names = FALSE)
colnames(variants) <- c("chrom", "pos")

# Prepare variant data for plotting
variant_positions <- toGRanges(data.frame(
  chr = variants$chrom,
  start = variants$pos,
  end = variants$pos
))

# Plot karyotype using the custom genome
kp <- plotKaryotype(genome = custom.genome)

# Plot variant density
kpPlotDensity(kp, data = variant_positions, col = rgb(0, 0, 1, 0.5), border = "darkblue", window.size = 200000)
kpAddBaseNumbers(kp)

# Add markers at density peaks
kpPlotMarkers(kp, data)

# Optionally, plot individual variant points
kpPoints(kp, data = variant_positions, y = runif(length(variant_positions), 0, 1), col = "blue", cex = 0.5)
kpPoints(kp, data = variant_positions, y = NULL)
