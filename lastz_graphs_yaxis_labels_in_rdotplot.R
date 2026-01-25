library(tidyverse)
library(ggplot2)

# Read rdotplot
dots <- readr::read_tsv("/home/newol210/macknight_oliver/flye_output_post_porechop/green_dorado_porechopped_assembly/lastz_green/contig_alignment_to_Rl_contig_6710.rdotplot")

plot(dots, type="l", 
     xlab = expression(Tr[To] ~ "R locus hap2 reference position (bp)"),
     ylab = "",
     yaxt = "n")

axis(side = 2,                 # left side (y-axis)
     at = c(57500, 227000, 430000, 538000, 575000),
     labels = c("A","B","C","D","E"),
     las = 1)

#title(ylab = expression(Tr[To] ~ "R locus hap1"), line = 1)

#abline(v = 6.72e+04, col = "red", lty = 3, lwd = 1.5)
abline(v = 43825, col = "red", lty = 3, lwd = 1.5)
abline(v = 34069, col = "grey", lty = 3, lwd = 1.5)
abline(v = 76241, col = "grey", lty = 3, lwd = 1.5)

abline(h = 115000, col = "black", lwd = 0.5)
abline(h = 339000, col = "black", lwd = 0.5)
abline(h = 521000, col = "black", lwd = 0.5)
abline(h = 555000, col = "black", lwd = 0.5)

text(43825,
     par("usr")[3] + diff(par("usr")[3:4])*0.035, 
     labels = expression(italic("TrRED LEAF")), 
     col = "red", 
     adj = -0.07,
     cex = 0.7)
text(34069,
     par("usr")[3] + diff(par("usr")[3:4])*0.035, 
     labels = "34069", 
     col = "black", 
     adj = -0.07,
     cex = 0.7)

text(76241,
     par("usr")[3] + diff(par("usr")[3:4])*0.035, 
     labels = "76241", 
     col = "black", 
     adj = -0.07,
     cex = 0.7)
