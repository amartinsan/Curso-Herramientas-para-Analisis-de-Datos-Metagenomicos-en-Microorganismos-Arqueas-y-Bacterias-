#!/bin/bash
#$ -N qiime_Vsearch
#$ -cwd
#$ -pe mpi 35


source /share/apps/External/Miniconda3-4.7.10/bin/activate
export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10


#Usando vsearch para la anotación

qiime feature-classifier classify-consensus-vsearch \
 --i-query rep-seqs.qza \
 --i-reference-reads /scratch/landa/silva/SILVA-138-SSURef-Full-Seqs.qza \
 --i-reference-taxonomy /scratch/landa/silva/Silva-v138-full-length-seq-taxonomy.qza \
 --o-classification taxo_vsearch.qza \
 --p-threads $NSLOTS

qiime metadata tabulate \
  --m-input-file taxo_vsearch.qza \
  --o-visualization taxo_vsearch.qzv

qiime taxa barplot \
 --i-table fil-table.qza \
 --i-taxonomy taxo_vsearch.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization barplots_vsearch.qzv

