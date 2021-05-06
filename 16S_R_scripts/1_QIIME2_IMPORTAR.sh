#!/bin/bash
#$ -N qiime2_importar
#$ -j y
#$ -cwd
#$ -pe mpi 4
source /share/apps/External/Miniconda3-4.7.10/bin/activate

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10
#Para single end 
#qiime tools import \
  #--type 'SampleData[SequencesWithQuality]' \
 # --input-path manifesto.csv \
 # --output-path demux.qza \
#  --input-format SingleEndFastqManifestPhred33
#para Paired-end
qiime tools import \
  --type SampleData[PairedEndSequencesWithQuality] \
  --input-format PairedEndFastqManifestPhred33 \
  --input-path manifesto.csv\
  --output-path demux.qza

#cortar adaptadores usados en la secuenciacion
#qiime cutadapt trim-paired \
#--i-demultiplexed-sequences untrimmed_demux.qza \
#--p-cores $NSLOTS \
#--p-front-f CCTACGGGNGGCWGCAG \
#--p-front-r GACTACHVGGGTATCTAATCC \
#--o-trimmed-sequences demux.qza

qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv \
  --verbose
