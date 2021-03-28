#!/bin/bash
#$ -N qiime_Gneiss
#$ -cwd
#$ -pe mpi 20

# Differential abundance is used to determine which features are significantly more/less abundant in different groups of samples

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#Option 1: Correlation-clustering

#qiime gneiss correlation-clustering \
#  --i-table table.qza \
#  --o-clustering hierarchy.qza
# metadata-column Debe ser una vairable categorica del metadata
#qiime gneiss dendrogram-heatmap \
#  --i-table table.qza \
#  --i-tree hierarchy.qza \
#  --m-metadata-file metadata.tsv \
#  --m-metadata-column lugar \
#  --p-color-map seismic \
#  --o-visualization heatmap.qzv

#Option 2: Gradient-clustering

# gradient column Debe ser una vairable categorica del metadata
qiime gneiss gradient-clustering \
  --i-table table.qza \
  --m-gradient-file metadata.tsv \
  --m-gradient-column lugar \
  --o-clustering gradient-hierarchy.qza

# metadata column Debe ser una vairable categorica del metadata
qiime gneiss dendrogram-heatmap \
  --i-table table.qza \
  --i-tree hierarchy.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column lugar \
  --p-color-map seismic \
  --o-visualization Gheatmap.qzv
