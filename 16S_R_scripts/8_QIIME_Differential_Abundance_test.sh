#!/bin/bash
#$ -N qiime_Diferential_abundance
#$ -cwd
#$ -pe mpi 8

#Nos permite hacer un test diferencial de abundancia a algun nivel taxonomico especifico. Despues de hacer el analisis de ANCOM, script 7

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#--p-level = nivel taxonomico

qiime taxa collapse \
  --i-table sediment-table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table sediment-table-l6.qza

qiime composition add-pseudocount \
  --i-table sediment-table-l6.qza \
  --o-composition-table comp-sediment-table-l6.qza

qiime composition ancom \
  --i-table comp-sediment-table-l6.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column pH \
  --o-visualization l6-ancom-subject.qzv
