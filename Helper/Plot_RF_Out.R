Plot_RF_Out=function(DF){
#purpose: make boxplot figure

library('ggplot2')
library('reshape2')
library('plyr')

DF2=DF[-1,]
DF2=data.frame(DF2)
DF2$time=factor(DF2$time,levels=c('Pre','1hr','6hr','24hr','48hr','2wk'))
names(DF2)[3]='probability'
DF2$probability=as.numeric(as.character(DF2$probability))
DF2$Y=mapvalues(DF2$Y,from=c(1,2), to=c('MP','Control'))
#reorder so MP is on right
DF2$Y=factor(DF2$Y,levels=c('Control','MP'))
names(DF2)[2]='Branch'
###Plotting
#DF2=readRDS('~/DF2') ###please place your path here to the file
#library('ggplot2')
p1 <- ggplot(DF2) +
	   geom_boxplot(aes(x=time,y=probability,color=Branch),lwd=1.1)+theme_minimal()+
	     theme(text = element_text(size=20))+scale_color_manual(values=c('gray48','steelblue'))+ theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
														     panel.background = element_blank())+xlab('')+ labs(color="")+
  theme(legend.position="top", legend.direction="horizontal")

  ggsave('steroid_classif.pdf',p1,width=6,height=4)

}
