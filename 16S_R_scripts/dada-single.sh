#!/bin/bash
#$ -N qiimedada2_single
#$ -cwd
#$ -pe mpi 40


source /share/apps/External/Miniconda3-4.7.10/bin/activate

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10

#Sustituor m y n por valores numericos basados en la calidad, se recomienda una calidad arriba de 25, si no se tiene buena calidad se puede usar arriba de 20 

qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left 6 \
  --p-trunc-len 424  \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats stats-dada2.qza \
  --p-max-ee 3.0 \
  --verbose
