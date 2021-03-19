
#Forma de hacer las boxplots sin usar las funciones preconstruidas de phyloseq o microbiome
#Se necesita importar el metadata y la tabla de otus con qiime2R

require(tidyverse)
require(phyloseq)
require(qiime2R)
metadata<-read.table("metadata.tsv", header=T, sep="\t",comment="", row.names=1)
metadata<-metadata[-1,]
#save rda variable
tableASV<-read_qza("table.qza") # tableASV$data matrix col sample row asv_id
ASVtable<-tableASV$data
write.csv(tableASV$data, file="tableASV.csv", quote=F) #print tsv
#save rda variable
filtered_table<-read_qza("filtered-table.qza")
filtered_table<-filtered_table$data
filtered_table<-filtered_table[order(rownames(filtered_table)),]
filtered_names<-rownames(filtered_table)
taxonomy<-read_qza("taxonomy_blast.qza") # taxonomy$data data.frame  $names Feature.ID Taxon Confidence
taxtable<-taxonomy$data %>% as_tibble() %>% separate(Taxon, sep=";", c("Kingdom","Phylum","Class","Order","Family","Genus","Species"))
taxtable<- taxtable %>% arrange(Feature.ID)
write.csv(taxtable, file="taxonomy.csv", quote=F, row.names=F)
#save rda varable
save(metadata,taxtable,ASVtable, file="qiime2data.rda")
filtered_taxonomy <- subset(taxtable, taxtable$Feature.ID %in% filtered_names)
filtered_taxonomy <- filtered_taxonomy[order(filtered_taxonomy$Feature.ID),]

save(metadata,filtered_table,filtered_taxonomy,file="filtered_qiime2data.rda")

sequences<-read_qza("rep-seqs.qza")
#sequences$data DNAstringset/Biostring width seq names
library(Biostrings) # as.character() names()
writeXStringSet(sequences$data, "sequences.fasta",format="fasta")
filtered_sequences<-read_qza("filtered-rep-seqs.qza") #apparently are ordered sorted
writeXStringSet(filtered_sequences$data,"filtered_sequences.fasta", format="fasta")
#rooted_tree<-read_qza("rooted-tree.qza")
#Se guardan en un archivo para poder cargar despues

load("qiime2data.rda")
#set deepest level in table
level<-1+3
#create factor with taxonomy name at specified level
factor_tax<-c()
for(i in rownames(taxtable)){
  tax<-paste(taxtable[i,2:level], collapse=";")
  tax<-str_replace_all(tax,";NA","")
  factor_tax[i]<-tax
}
factor_tax<-factor(factor_tax)

#create matrix number of rows, levels in taxonomy factor, number of cols samp
level_mat<-matrix(0,length(levels(factor_tax)),dim(ASVtable)[2])
dimnames(level_mat)[[1]]<-levels(factor_tax)
dimnames(level_mat)[[2]]<-dimnames(ASVtable)[[2]]

#checK if rownames len of filt_table matches length ot filt_taxonomy
#for(i in 1:length(rownames(filtered_taxonomy))){
#    level_mat[factor_tax[i],]<-level_mat[factor_tax[i],] + filtered_table[i,]
#    }
#this compare rownames in Table and Feature.ID in taxonomy, same as above, but
#(in theory) does not require sorted taxonomy(dataframe) nor table(matrix)
for(i in 1:length(rownames(taxtable))){
  level_mat[factor_tax[i],]<-level_mat[factor_tax[i],] + ASVtable[as.character(taxtable$Feature.ID[i]),]
}

#transform matrix into relative abundance per sample
level_mat.rel_ab<-level_mat
for(i in 1:dim(level_mat)[[2]] ){
  level_mat.rel_ab[,i]<-level_mat[,i]/sum(level_mat[,i])
}

#new matrix to collapse categories under specified frequency cutoff
#into others categorie
cutoff<-0.035
level_mat.collapsed<-matrix(0,1,dim(ASVtable)[2])
rownames(level_mat.collapsed)<-c("others")
for(i in 1:dim(level_mat.rel_ab)[[1]]){
  #if (sum(level_mat.rel_ab[i,]) >= cutoff){ #if sum over samples for the category
  if  (any(level_mat.rel_ab[i,] >= cutoff)){ #if any sample for the category
    #the category stays the same
    rname<-rownames(level_mat.collapsed)
    level_mat.collapsed<-rbind(level_mat.rel_ab[i,] , level_mat.collapsed)
    rownames(level_mat.collapsed)<-c(rownames(level_mat.rel_ab)[i], rname)
  }
  else { #collapse the category into "others"
    #retained[i]<-F
    level_mat.collapsed["others",]<-level_mat.collapsed["others",] +level_mat.rel_ab[i,]
  }
}


##sort samples by desired order
#A)order by metadata variable values, replace * by desired variable
#order_s<-rownames(metadata)[order(metadata$*)]
#B)order by taxonomic abundance, replace * by row with desired taxonomy
#order_s<-dimnames(level_mat.collapsed[,order(level_mat.collapsed[*,])])[[2]]
##C) clustering
##transfrom matrix into dataframe with library and ggplot bar grap

library("ggplot2")
library("reshape2")
#Realmente es una tabla a la que se le hace melt y esa se grafica

tbl<-melt(level_mat.collapsed)
names(tbl)<-c("categories", "samples", "rel_freq")
tbl$categories <- gsub("D_[0-9]__","", tbl$categories, perl=T)

#sort x labels se usa para ordenar con los datos del metadata
mtype=as.character(metadata$Sample[order(paste(metadata$Type,metadata$Sample))])
mtype<-c(mtype[19:32],mtype[42:59],mtype[33:41], mtype[1:18], mtype[60:78])
tbl$samples<-factor(tbl$samples, levels=mtype)

#paleta random de colores
color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
set.seed(19)
color_b=c(sample(color, 54), "gray")

figname="class"
fig_name=paste(figname,".jpg", sep="")
jpeg(fig_name, width = 20*300, height = 12*300, res = 300)
ggplot(tbl, aes(x=samples, y=rel_freq, fill=categories, width=.6)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=color_b) +
  ylab("relative abundance")+
  xlab("")+
  blank_theme+
  scale_x_discrete(limits=mtype)+ #vector with desired order of samples
  annotate("text", x=10, y=-0.07, label="DEEP", size=10)+
  annotate("text", x=7, y=-0.07, label="MAX", size=10)+
  annotate("text", x=47, y=-0.07,label="AAIW",size=10)+
  annotate("text", x=20, y=-0.07, label="MIN", size=10)+
  annotate("text", x=70, y=-0.07, label="SED", size=10)+
  annotate("segment", x=1, xend=14, y=-.02, yend=-.02, size=5,color="green")+
  annotate("segment", x=15,xend=32, y=-.02, yend=-.02, size=5,color="orange")+
  annotate("segment", x=33,xend=41, y=-.02, yend=-.02, size=5,color="red")+
  annotate("segment", x=42,xend=59, y=-.02, yend=-.02, size=5,color="blue")+
  annotate("segment", x=60,xend=78, y=-.02, yend=-.02, size=5,color="pink")+
  theme(axis.title.y=element_text(size=14, colour="black", angle=90),
        axis.text.x=element_blank(), #element_text(size=9,angle=90),
        axis.line.y=element_line(color="black"),
        axis.title.x=element_text(size=18, angle=0),
        plot.title=element_text(size=24),
        strip.text.x =element_text(size=12),
        strip.background=element_rect(color="black", fill="white"),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(color="gray"),
        panel.grid.minor.y=element_line(color="gray"),
        legend.text=element_text(size=10),
        legend.title=element_blank(),
        legend.position="bottom"
  )
dev.off()


#library("plyr")
#library("RColorBrewer")
#library(stringr)
