#!/usr/bin/Rscript
##############################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Wed Jun 25 14:20:52 2014
##############################################

dat<-read.delim(file = "tss_4k_hist10_1-12_histogram.txt",row.names=1)

idx<-seq(from = 1,by = 3,length.out = 18)
d<-dat[,idx]

col.nms<-gsub(pattern = ".*?tags\\.TagDir_(.*?)\\.Coverage",replacement = "\\1",x = colnames(d))


idx<-grepl("EB",col.nms)
print(idx)
col.nms<-col.nms[idx]
d<-d[,idx]

ymax<-ceiling(max(d))

cols<-rainbow(2)
cols[3]<-"black"

pdf("histogram_tss.pdf")
plot(x = 1:nrow(d),y=d[,1],col=cols[1],lty=1,type="l",ylim = c(0,ymax),xlab="Distance to TSS",ylab="Normalized signal",pch=1,lwd=2,las=1,xaxt = "n")
ats<-c(1,100,200,300,400)
labs<-c("-2k","-1k","0","1k","2k")
axis(side = 1,at = ats,labels = labs)

for(i in 2:2){
  lines(x = 1:nrow(d),y=d[,i],col=cols[i],lty=i,pch=i,lwd=2)
}
legend("topright",legend = col.nms,lty=1:2,col=cols,lwd=2,bty="n")
title("ATAC-Seq (HiSeq)")
dev.off()


## Fold change to its -2000bp -200bp signals

pdf("histogram_tss_foldchange.pdf")
d.200k<-colMeans(d[1:20,])
dd<-t(t(d)/d.200k)
ymax<-ceiling(max(dd))

plot(x = 1:nrow(dd),y=dd[,1],col=cols[1],lty=1,type="l",ylim = c(0,ymax),xlab="Distance to TSS",ylab="Fold Change to its upstream 1800-2000bp region signal",pch=1,lwd=2,las=1,xaxt = "n")
ats<-c(1,100,200,300,400)
labs<-c("-2k","-1k","0","1k","2k")
axis(side = 1,at = ats,labels = labs)

for(i in 2:2){
  lines(x = 1:nrow(dd),y=dd[,i],col=cols[i],lty=i,pch=i,lwd=2)
}
legend("topright",legend = col.nms,lty=1:2,col=cols,lwd=2,bty="n")
title("ATAC-Seq (HiSeq)")
dev.off()


