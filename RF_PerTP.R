#Purpose: Train random forest based on all features
#Date Modified: July 19, 2019

library('Biobase')
library('randomForest')
library('pROC')
library('plyr')
library('foreach')
library('doParallel')
source('Helper/Plot_RF_Out.R')
###################
#read in data
###################

#read data in after doing clustering
load('Data.rda')
Build=Data

#frequency features
FeatureMat=Build[[2]]

#get appropriate functional marker features
FuncInd=readRDS('Helper/FunctionalInds')
CN=as.matrix(colnames(Build[[4]])[FuncInd])
FuncDF=Build[[1]]
#get proper indices
ARes=apply(CN,1,function(x) which(grepl(x,colnames(FuncDF))))
UInds=sort(unique(unlist(ARes)))
FuncDF=FuncDF[,UInds]

#fix there column names so that they are all unique 
ForC=1:ncol(FuncDF)
NewName=paste(colnames(FuncDF),ForC,sep='_')
colnames(FuncDF)=NewName

#now combine both information sources
FeatureMat=cbind(FeatureMat,FuncDF)

#add metadata
Out=readRDS('Helper/Out')

#enumerate timepoints that we need
TPs=c('Pre','1hr','6hr','24hr','48hr','2wk')

#store the models we learn 
Models=list()
count=1
Wilcox=c()
AUC=c()

DF=rep(0,3)

for(t in 1:6){
Sub=which(Out[,4]==TPs[t])

#get subset of metadata
SubOut=Out[Sub,]
SubFeat=FeatureMat[Sub,]

YY=as.factor(SubOut[,3])

#get the data ready to give to the random forest
X=SubFeat
Y=YY

#################################
##for each approach##
######################
#set up parallelization
cl=makeCluster(20)
registerDoParallel(cl)

rfCustom=function(L1,L2){
ansVec=cbind(L1$ansVec,L2$ansVec)
modImp=rbind(L1$modImp,L2$modImp)
return(list(ansVec=ansVec,modImp=modImp))
}

itSeq=1:200

#Set X2, the data structure in our RF to X
X2=X

RFIter=foreach(s=itSeq,.combine=rfCustom,.packages=c('class','randomForest','e1071')) %dopar% {

repeat{
train=sample(seq(length(Y)),length(Y)*.5)
if(length(unique(Y[train]))==2)
break
}
test=seq(length(Y))[-train]
ansVec=rep(NA,length(Y))
mod=randomForest(X2[train,],Y[train])
predVec=predict(mod,X2[test,],type='prob')[,2]
ansVec[test]=as.numeric(predVec)
return(list(ansVec=ansVec))
} #RF iter loop

ansMat=RFIter$ansVec
ans=rowMedians(ansMat,na.rm=TRUE)
print(paste('we are on timepoint',TPs[t]))
r=roc(Y, ans,direction='<')$auc
print(r)
w=wilcox.test(ans ~ Y)$p.value
print(w)
AUC=c(AUC,r)
Wilcox=c(Wilcox,w)
stopCluster(cl)

time=rep(TPs[t],length(Y))
NewFeat=cbind(time,Y,ans)
DF=rbind(DF,NewFeat)
} ###for timepoint

names(AUC)=TPs
names(Wilcox)=TPs

#make plot
Plot_RF_Out(DF)
