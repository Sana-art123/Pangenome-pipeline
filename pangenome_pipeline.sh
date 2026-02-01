conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda create -n orthofinder -c bioconda -c conda-forge orthofinder -y
source $(conda info --base)/etc/profile.d/conda.sh
conda activate orthofinder
orthofinder -h
cd /home/laraib/Desktop/alternaria_proteomes
orthofinder -f . -t 8
python3 << EOF
import pandas as pd
results_dir = "/home/laraib/Desktop/alternaria_proteomes/OrthoFinder/Results_Dec21/"
gene_count_file = results_dir + "Orthogroups.GeneCount.tsv"
gene_count = pd.read_csv(gene_count_file, sep='\t', index_col=0)
core_genes = gene_count[gene_count.min(axis=1) > 0]
core_genes.to_csv(results_dir + "Core_Genes.tsv", sep='\t')
accessory_genes = gene_count[(gene_count.min(axis=1) == 0) & (gene_count.max(axis=1) > 1)]
accessory_genes.to_csv(results_dir + "Accessory_Genes.tsv", sep='\t')
unassigned_file = results_dir + "Orthogroups_UnassignedGenes.tsv"
with open(unassigned_file, 'r') as f:
    unique_genes = f.readlines()
with open(results_dir + "Unique_Genes.tsv", 'w') as out:
    out.writelines(unique_genes)
EOF
Rscript -e "library(ggplot2); library(dplyr); library(readr); results_dir='/home/laraib/Desktop/alternaria_proteomes/OrthoFinder/Results_Dec21/'; core=read_tsv(paste0(results_dir,'Core_Genes.tsv')); accessory=read_tsv(paste0(results_dir,'Accessory_Genes.tsv')); unique=read_tsv(paste0(results_dir,'Unique_Genes.tsv'),col_names=FALSE); counts=data.frame(Category=c('Core','Accessory','Unique'), Count=c(nrow(core),nrow(accessory),nrow(unique))); ggplot(counts,aes(x=Category,y=Count,fill=Category))+geom_bar(stat='identity')+scale_fill_manual(values=c('steelblue','orange','green'))+theme_minimal()+ylab('Number of Genes')+xlab('')+ggtitle('Fungal Pangenome Composition'); ggsave(paste0(results_dir,'Pangenome_Composition.png'),width=6,height=4)"

