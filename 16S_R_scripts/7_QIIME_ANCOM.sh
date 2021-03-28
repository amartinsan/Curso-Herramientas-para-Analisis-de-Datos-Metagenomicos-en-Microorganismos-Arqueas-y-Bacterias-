#!/bin/bash
#$ -N qiime_ANCOM
#$ -cwd
#$ -pe mpi 20

#ANCOM can be applied to identify features that are differentially abundant (i.e. present in different abundances) across sample groups. Es conveniente tener más metadatos

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#--pwhere filtra la tabla para tener solo los datos seleccionados

#qiime feature-table filter-samples \
#  --i-table table.qza \
#  --m-metadata-file metadata.tsv \
#  --p-where "[lugar]='zona3'" \
#  --o-filtered-table sediment-table.qza

#qiime composition add-pseudocount \
#  --i-table sediment-table.qza \
#  --o-composition-table comp-sediment-table.qza

# metadata column tiene que ser categorico
qiime composition ancom \
  --i-table comp-sediment-table.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column lugar \
  --o-visualization ancom-subject.qzv
