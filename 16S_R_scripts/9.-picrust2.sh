#!/bin/bash
#$ -N picrust2
#$ -cwd
#$ -pe mpi 10


source /share/apps/External/Miniconda3-4.7.10/bin/activate

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10
 
qiime picrust2 full-pipeline \
   --i-table fil-table.qza \
   --i-seq rep-seqs.qza \
   --output-dir q2-picrust2_output \
   --p-threads 1 \
   --p-hsp-method pic \
   --p-max-nsti 2 \
   --verbose


#qiime feature-table summarize \
#   --i-table q2-picrust2_output/pathway_abundance.qza \
#   --o-visualization q2-picrust2_output/pathway_abundance.qzv


