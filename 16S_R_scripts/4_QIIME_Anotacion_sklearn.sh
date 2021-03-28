#!/bin/bash
#$ -N qiime_sklearn
#$ -cwd
#$ -j y
#$ -pe mpi 16
#$ -l h_vmem=8G

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#Skelarn  de todo el 16s con OTUs al 99%
#sklearn annotation, usar opcion default de --p-n-jobs 1 *

qiime feature-classifier classify-sklearn \
 --i-classifier /scratch/acornejo/secuencias/sklearn-SILVA132/silva-132-99-nb-classifier.qza \
 --i-reads rep-seqs.qza \
 --o-classification taxo_sklearn99.qza \

qiime metadata tabulate \
  --m-input-file taxo_sklearn99.qza \
  --o-visualization taxo_sklearn99.qza

qiime taxa barplot \
 --i-table fil-table.qza \
 --i-taxonomy taxo_sklearn99.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization barplots_sklearn99.qzv

#Usando el clasificador sklearn entrenado con los oligos para las regiones V3-V4 del 16s ribosomal
#sklearn annotation, usar opcion default de --p-n-jobs 1 *

qiime feature-classifier classify-sklearn \
 --i-classifier /scratch/acornejo/secuencias/sklearn-SILVA132/silva132_v3v4-classifier.qza \
 --i-reads rep-seqs.qza \
 --o-classification taxo_sklearnV3V4.qza \

qiime metadata tabulate \
  --m-input-file taxo_sklearnV3V4.qza \
  --o-visualization taxo_sklearnV3V4.qza

qiime taxa barplot \
 --i-table fil-table.qza \
 --i-taxonomy taxo_sklearnV3V4.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization barplots_skeV3V4.qzv

