#!/bin/bash
#$ -N qiime2_feature
#$ -cwd
#$ -pe mpi 35

source /share/apps/External/Miniconda3-4.7.10/bin/activate
export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10


# secuencias representativas, tabular secuencias
qiime feature-table tabulate-seqs \
 --i-data rep-seqs.qza \
 --o-visualization rep-seqs.qzv

#tabular estadisticas denoise dada2
#qiime metadata tabulate \
# --m-input-file denoising-stats.qza \
# --o-visualization denoising-stats.qzv

qiime feature-table filter-features \
  --i-table table.qza \
  --p-min-frequency 10 \
  --o-filtered-table fil-table.qza

# Feature table resumen
qiime feature-table summarize  \
 --i-table fil-table.qza  \
 --o-visualization fil-table.qzv \
 --m-sample-metadata-file metadata.tsv

# Feature table resumen
qiime feature-table summarize  \
 --i-table table.qza  \
 --o-visualization table.qzv \
 --m-sample-metadata-file metadata.tsv
