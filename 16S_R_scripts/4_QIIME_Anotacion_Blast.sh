#!/bin/bash
#$ -N qiiime_Blast
#$ -cwd
#$ -j y
#$ -pe mpi 4


export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#usando Blast (Consesus BLAST anotation)

qiime feature-classifier classify-consensus-blast \
 --i-query rep-seqs.qza \
 --i-reference-reads /scratch/acornejo/secuencias/silva_database132/Silva_99OTUS_sequence.qza \
 --i-reference-taxonomy /scratch/acornejo/secuencias/silva_database132/Silva_taxonomy.qza \
 --o-classification taxo-blast.qza

qiime metadata tabulate \
  --m-input-file taxo-blast.qza \
  --o-visualization taxo-blast.qzv \

qiime taxa barplot \
  --i-table fil-table.qza \
  --i-taxonomy taxo-blast.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization barplots_Blast.qzv

