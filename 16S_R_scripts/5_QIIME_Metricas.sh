#$ -N METRICAS_alpharare
#$ -cwd
#$ -pe mpi 35

source /share/apps/External/Miniconda3-4.7.10/bin/activate

export PATH=/share/apps/External/Miniconda3-4.6.14/envs/qiime2-2019.10/bin:$PATH
conda activate qiime2-2019.10




#Filogenia de las secuencias representativas 

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-repseqs.qza \
  --o-masked-alignment masked-aligned-repseqs.qza \
  --o-tree unrootedtree.qza \
  --o-rooted-tree rootedtree.qza

#Grafica de alfa rarefacción
qiime diversity alpha-rarefaction \
  --i-table fil-table.qza \
  --i-phylogeny rootedtree.qza \
  --p-max-depth  12883 \
  --m-metadata-file metadata.tsv \
  --o-visualization rare_curve.qzv


#Caluclar las metricas, se genera una carpeta con todos los archivos: core-metrics-results

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rootedtree.qza \
  --i-table fil-table.qza \
  --p-sampling-depth 12883 \
  --m-metadata-file metadata.tsv \
  --output-dir core-metrics-results
 

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
