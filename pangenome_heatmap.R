library(ggplot2)
library(pheatmap)
library(dplyr)
library(readr)

results_dir <- "/home/laraib/Desktop/alternaria_proteomes/OrthoFinder/Results_Dec21/"

gene_matrix <- read_tsv(paste0(results_dir, "Orthogroups.GeneCount.tsv"))
gene_matrix[gene_matrix > 1] <- 1
rownames(gene_matrix) <- gene_matrix$`Orthogroup`
gene_matrix <- gene_matrix[, -1]
gene_matrix <- as.matrix(gene_matrix)

pheatmap(
  gene_matrix,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  color = colorRampPalette(c("white", "steelblue"))(50),
  main = "Fungal Pangenome Gene Presence/Absence"
)
ggsave(paste0(results_dir, "Pangenome_Heatmap.png"), width = 10, height = 8)

