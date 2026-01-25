# Load necessary libraries
library(karyoploteR)
library(GenomicRanges)
library(readr)

# Read genome.txt (chromosome names and lengths)
genome_data <- read_delim("/Users/oliver/Library/Mobile Documents/com~apple~CloudDocs/PhD records/RNASeq_2025/UTM_hap1_ref_for_karyotypeR.txt", delim = "\t", col_names = FALSE)

# Rename columns for clarity
colnames(genome_data) <- c("chrom", "length")

# Convert to GRanges object
custom.genome <- GRanges(
  seqnames = genome_data$chrom,
  ranges = IRanges(start = 1, end = genome_data$length)
)
seqlengths(custom.genome) <- genome_data$length

# Read first variant dataset
variants1 <- read_delim("/Users/oliver/Library/Mobile Documents/com~apple~CloudDocs/PhD records/RNASeq_2025/chromosome_and_positions_coseg_vars_NoneVsHigh.txt", delim = "\t", col_names = FALSE)
colnames(variants1) <- c("chrom", "pos")
variant_positions1 <- toGRanges(data.frame(
  chr = variants1$chrom,
  start = variants1$pos,
  end = variants1$pos
))

# Read second variant dataset
variants2 <- read_delim("/Users/oliver/Library/Mobile Documents/com~apple~CloudDocs/PhD records/RNASeq_2025/chromosome_and_positions_coseg_vars_LowVsHigh.txt", delim = "\t", col_names = FALSE)
colnames(variants2) <- c("chrom", "pos")
variant_positions2 <- toGRanges(data.frame(
  chr = variants2$chrom,
  start = variants2$pos,
  end = variants2$pos
))

# Define window size for binning
window.size <- 200000

# Compute max density from both datasets
max_density1 <- max(countOverlaps(tileGenome(seqinfo(custom.genome), tilewidth = window.size), variant_positions1))
max_density2 <- max(countOverlaps(tileGenome(seqinfo(custom.genome), tilewidth = window.size), variant_positions2))
shared_max_density <- max(max_density1, max_density2)

# Plot karyotype
kp <- plotKaryotype(genome = custom.genome, plot.type = 2)

# Plot densities with a common y-axis scale
kpPlotDensity(kp, data = variant_positions1, col = rgb(1, 0, 0, 0.5), border = "darkred", window.size = window.size, ymax = shared_max_density)
kpPlotDensity(kp, data = variant_positions2, col = rgb(0, 0, 1, 0.5), border = "darkblue", window.size = window.size, ymax = shared_max_density)

# Add base numbers
kpAddBaseNumbers(kp)

# Optionally, plot individual variant points
kpPoints(kp, data = variant_positions1, y = runif(length(variant_positions1), 0, 1), col = "red", cex = 0.5)
kpPoints(kp, data = variant_positions2, y = runif(length(variant_positions2), 0, 1), col = "blue", cex = 0.5)