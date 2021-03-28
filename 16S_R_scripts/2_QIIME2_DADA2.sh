#!/bin/bash
#$ -N qiime2_dada2
#$ -cwd
#$ -j y
#$ -l lenta
#$ -pe mpi 12
#$ -l h_vmem=12

export PATH=/scratch/share/apps/miniconda3-4.6.14/envs/qiime2-2019.4/bin:$PATH
module load programs/qiime2-2019.4
source activate qiime2-2019.4

#Sustituor m y n por valores numericos basados en la calidad, se recomienda una calidad arriba de 25, si no se tiene buena calidad se puede usar arriba de 20

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 7 \
  --p-trim-left-r 10 \
  --p-trunc-len-f 296 \
  --p-trunc-len-r 231 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --p-n-threads $NSLOTS
