## =====================================================================
## KEGG enrichment (ORA + GSEA) without clusterProfiler
## Inputs: full eggNOG-mapper output, full edgeR table, significant-gene file
## Needs: dplyr, tidyr, readr, stringr, tibble, ggplot2, fgsea (Bioconductor)
## =====================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(readr); library(stringr)
  library(tibble); library(ggplot2); library(fgsea)
})
set.seed(42)

## ---- 1. Settings (EDIT THESE) --------------------------------------
emapper_file <- "/home/newol210/macknight_oliver/eggnog_mapper_working_dir/braker_asterisks_removed_aa_eggnog.emapper.annotations"   # FULL eggNOG output, all genes
all_file     <- "/home/newol210/macknight_oliver/EdgeR_RNAseq_output_2025/dge_table_genes_None_vs_High_brakerGTF.txt"  # FULL edgeR table: gene, logFC, PValue, FDR, ...
sig_file     <- "/home/newol210/macknight_oliver/EdgeR_RNAseq_output_2025/significant_genes_none_vs_high_brakerGTF_attempt4_FDR_0.005_w_eggNOG_annotations.txt"
out_dir      <- "/home/newol210/macknight_oliver/EdgeR_RNAseq_output_2025/kegg_enrichment"

min_size      <- 5      # pathway size filter (genes in universe)
max_size      <- 500
fdr_cut       <- 0.05   # significance threshold for enrichment results
drop_disease  <- TRUE   # drop KEGG "Human Diseases" maps (map05xxx)
drop_overview <- TRUE   # drop giant global/overview maps (map01100 etc.)

dir.create(out_dir, showWarnings = FALSE)

# BRAKER transcript ID (g1.t1) -> gene ID (g1). Safe if IDs are already gene-level.
to_gene <- function(x) sub("\\.t[0-9]+$", "", x)

## ---- 2. Gene-to-pathway table from eggNOG-mapper -------------------
emap <- read_tsv(emapper_file, comment = "##", na = "-", show_col_types = FALSE) %>%
  rename(query = `#query`) %>%
  mutate(gene = to_gene(query))

term2gene <- emap %>%
  select(gene, KEGG_Pathway) %>%
  filter(!is.na(KEGG_Pathway)) %>%
  separate_rows(KEGG_Pathway, sep = ",") %>%
  filter(str_detect(KEGG_Pathway, "^map")) %>%      # reference pathways only
  distinct(term = KEGG_Pathway, gene)

if (drop_disease)  term2gene <- filter(term2gene, !str_detect(term, "^map05"))
if (drop_overview) term2gene <- filter(term2gene, !term %in% c(
  "map01100","map01110","map01120","map01200","map01210","map01212",
  "map01220","map01230","map01232","map01240","map01250"))

# Pathway names (cosmetic; falls back to IDs if the download is blocked)
path_names <- tryCatch(
  read_tsv("https://rest.kegg.jp/list/pathway", col_names = c("term", "name"),
           show_col_types = FALSE) %>% mutate(term = sub("^path:", "", term)),
  error = function(e) {
    message("Could not download KEGG pathway names; using IDs instead.")
    tibble(term = unique(term2gene$term), name = unique(term2gene$term))
  })

cat("Pathways:", n_distinct(term2gene$term),
    "| annotated genes:", n_distinct(term2gene$gene), "\n")

## ---- 3. edgeR results: universe and foreground ---------------------
# Full table (every tested gene). Collapse isoforms: keep the most significant per gene.
res <- read_tsv(all_file, show_col_types = FALSE) %>%
  mutate(gene = to_gene(gene)) %>%
  group_by(gene) %>% slice_min(PValue, n = 1, with_ties = FALSE) %>% ungroup()

# Significant file: read first 5 fields by position (header is ragged / has spaces)
ln <- readLines(sig_file)[-1]; ln <- ln[nzchar(ln)]
f  <- strsplit(ln, "\t", fixed = TRUE)
sig_tbl <- tibble(
  gene   = to_gene(sapply(f, `[`, 1)),
  logFC  = as.numeric(sapply(f, `[`, 2)),
  PValue = as.numeric(sapply(f, `[`, 4)),
  FDR    = as.numeric(sapply(f, `[`, 5))
) %>% group_by(gene) %>% slice_min(PValue, n = 1, with_ties = FALSE) %>% ungroup()

# Universe = tested genes that carry a KEGG pathway annotation
annotated <- unique(term2gene$gene)
universe  <- intersect(res$gene, annotated)

# Foreground sets. Check your contrast: positive logFC = higher in the numerator group.
fg_sets <- list(
  all      = sig_tbl$gene,
  positive = sig_tbl$gene[sig_tbl$logFC > 0],
  negative = sig_tbl$gene[sig_tbl$logFC < 0]
)

## Sanity checks
cat("Significant genes found in full table:", mean(sig_tbl$gene %in% res$gene),
    "(should be 1; if not, IDs differ between files)\n")
cat("Tested genes with KEGG pathway:", round(mean(res$gene %in% annotated), 3), "\n")
cat("Universe size:", length(universe), "\n")
for (nm in names(fg_sets))
  cat(sprintf("Foreground '%s': %d total, %d annotated\n", nm,
              length(fg_sets[[nm]]), length(intersect(fg_sets[[nm]], universe))))

## ---- 4. Hypergeometric ORA -----------------------------------------
run_ora <- function(sig_genes, label) {
  sig_genes <- intersect(sig_genes, universe)
  N <- length(universe); n <- length(sig_genes)
  if (n == 0) return(tibble())
  term2gene %>%
    filter(gene %in% universe) %>%
    group_by(term) %>%
    summarise(K = n(),                                   # pathway genes in universe
              k = sum(gene %in% sig_genes),              # pathway genes in foreground
              genes = paste(gene[gene %in% sig_genes], collapse = ";"),
              .groups = "drop") %>%
    filter(K >= min_size, K <= max_size, k >= 1) %>%
    mutate(pvalue      = phyper(k - 1, K, N - K, n, lower.tail = FALSE),  # P(X >= k)
           fold_enrich = (k / n) / (K / N),
           padj        = p.adjust(pvalue, method = "BH"),
           set = label, n_fg = n, N_universe = N) %>%
    left_join(path_names, by = "term") %>%
    mutate(name = coalesce(name, term)) %>%
    arrange(padj)
}

ora_res <- Map(run_ora, fg_sets, names(fg_sets))
for (nm in names(ora_res))
  if (nrow(ora_res[[nm]]) > 0)
    write_tsv(ora_res[[nm]], file.path(out_dir, paste0("ORA_", nm, ".tsv")))

## ---- 5. ORA dotplots -----------------------------------------------
plot_ora <- function(df, title, top = 20) {
  d <- df %>% filter(padj < fdr_cut) %>% slice_head(n = top)
  if (nrow(d) == 0) { message("No significant pathways for: ", title); return(NULL) }
  ggplot(d, aes(fold_enrich, reorder(name, fold_enrich), size = k, colour = padj)) +
    geom_point() +
    scale_colour_viridis_c(direction = -1) +
    labs(title = title, x = "Fold enrichment", y = NULL, size = "Genes", colour = "FDR") +
    theme_bw()
}

for (nm in names(ora_res)) {
  if (nrow(ora_res[[nm]]) == 0) next
  p <- plot_ora(ora_res[[nm]], paste("KEGG ORA:", nm))
  if (!is.null(p)) ggsave(file.path(out_dir, paste0("ORA_", nm, ".pdf")), p,
                          width = 8, height = 6)
}

## ---- 6. GSEA with fgsea (ranked, no cutoff) ------------------------
# Signed -log10(p) ranking from the FULL table (floor avoids Inf for p = 0)
ranks <- res %>%
  mutate(rank = sign(logFC) * -log10(pmax(PValue, 1e-300))) %>%
  filter(is.finite(rank)) %>%
  arrange(desc(rank)) %>%
  { setNames(.$rank, .$gene) }

pathways <- split(term2gene$gene, term2gene$term)

gsea <- fgseaMultilevel(pathways, ranks, minSize = min_size, maxSize = max_size) %>%
  as_tibble() %>%
  mutate(leadingEdge = vapply(leadingEdge, paste, character(1), collapse = ";")) %>%
  left_join(path_names, by = c("pathway" = "term")) %>%
  mutate(name = coalesce(name, pathway)) %>%
  arrange(padj)

write_tsv(gsea, file.path(out_dir, "GSEA_fgsea.tsv"))

d <- gsea %>% filter(padj < fdr_cut) %>% slice_head(n = 20)
if (nrow(d) > 0) {
  p_gsea <- ggplot(d, aes(NES, reorder(name, NES), fill = NES > 0)) +
    geom_col() +
    scale_fill_manual(values = c(`TRUE` = "firebrick", `FALSE` = "steelblue"),
                      labels = c(`TRUE` = "Positive logFC", `FALSE` = "Negative logFC"),
                      name = NULL) +
    labs(title = "KEGG GSEA (fgsea)", x = "Normalised enrichment score", y = NULL) +
    theme_bw()
  ggsave(file.path(out_dir, "GSEA_fgsea.pdf"), p_gsea, width = 8, height = 6)
} else message("No significant GSEA pathways at FDR < ", fdr_cut)

## ---- 7. Reproducibility --------------------------------------------
writeLines(capture.output(sessionInfo()), file.path(out_dir, "sessionInfo.txt"))
