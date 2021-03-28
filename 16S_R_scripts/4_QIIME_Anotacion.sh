#!/bin/bash
#$ -N Taxa_Anotacion
#$ -cwd
#$ -j y
#$ -pe mpi 16
#$ -l h_vmem=8G

export PATH=/share/apps/External/Miniconda3-4.5.11/envs/qiime2-2018.11/bin:$PATH
#module load programs/qiime2-2018.11
#source activate qiime2-2018.11

#Usando vsearch para la anotación

qiime feature-classifier classify-consensus-vsearch \
 --i-query rep-seqs.qza \
 --i-reference-reads /scratch/acornejo/secuencias/silva_database132/Silva_99OTUS_sequence.qza \
 --i-referencex-taxonomy /scratch/acornejo/secuencias/silva_database132/Silva_taxonomy.qza \
 --o-classification taxo_vsearch.qza \
 --p-n-threads $NSLOTS

qiime metadata tabulate \
  --m-input-file taxo_vsearch.qza \
  --o-visualization taxo_vsearch.qzv

qiime taxa barplot \
 --i-table table.qza \
 --i-taxonomy taxo_vsearch.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization vsearch_barplots.qzv

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
 --i-table table.qza \
 --i-taxonomy taxo_sklearn99.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization ske99_barplots.qzv

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
 --i-table table.qza \
 --i-taxonomy taxo_sklearnV3V4.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization skeV3V4_barplots.qzv

