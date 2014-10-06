suppressPackageStartupMessages(library(IRanges))
suppressPackageStartupMessages(library(GenomicRanges))

#On accre
myfile="Homo_sapiens.NCBI36.54.gtf"

gtf <- read.delim(myfile, header=FALSE,stringsAsFactors=FALSE)
colnames(gtf) <- c("seqname", "source", "feature", "start", "end", "score", "strand", "frame",      
                   "attributes")

chronly <- c(1:22, "X", "Y", "MT")
gtf <- gtf[as.character(gtf$seqname) %in% chronly, ] # Cleanup to remove non-chromosome rows
gtf <- gtf[as.character(gtf$feature) == "exon",]     # Only exon region
gtf[as.character(gtf$seqname) == "MT",1]<-"M"

gene.name <- gsub(".*gene_name (.*?);.*", "\\1", gtf$attributes) #get gene_name from attributes column
gene.ids <-  gsub(".*gene_id (.*?);.*", "\\1", gtf$attributes) #get gene_id from attributes column
transcript.ids<- gsub(".*transcript_id (.*?);.*", "\\1", gtf$attributes) #get transcript_id from attributes column
gene.index<-gene.ids !=""                    #skip those have no value

ensg2symbol<-data.frame("EnsemblID"=gene.ids[gene.index],"Symbol"=gene.name[gene.index],stringsAsFactors=FALSE)
ensg2symbol<-unique(ensg2symbol)
ensg2symbol2<-ensg2symbol[,2]
names(ensg2symbol2)<-ensg2symbol[,1]
gene.gr<-GRanges(seqnames=gtf$seqname[gene.index],
                 ranges=IRanges(gtf$start[gene.index],gtf$end[gene.index]),
                 strand=gtf$strand[gene.index],
                 tx_id=transcript.ids[gene.index],
                 gene_id=gene.ids[gene.index],
                 gene_name=gene.name[gene.index])
gene.gr.list<-split(gene.gr,gene.ids[gene.index])
save(gene.gr.list,file="ensemble_NCBI36_54_GenomeRangesList_ENSG.RData")

#Get gene Length, takes a long time
system.time(gene.exon.length<-lapply(gene.gr.list,function(x) sum(width(reduce(x)))) )
#user    system   elapsed 
#14931.197    19.129 14973.501 
gene.exon.length<-unlist(gene.exon.length) 
save(gene.exon.length,file="gene.exon.length.use.ENSG.Rdata")

#A matrix
dat<-data.frame(geneid=gene.ids[gene.index],genesymbol=gene.name[gene.index],stringsAsFactors=FALSE)
dat<-unique(dat)
dat$genelength<-gene.exon.length[dat$geneid]
write.csv(dat,file="gene_length_union.csv",row.names=FALSE)

