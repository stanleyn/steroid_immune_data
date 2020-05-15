#MatchIndex
#Purpose: the prupose of this is to match each row in the matrix to its Baseline measurement

Out=readRDS(paste(Target,'Helper','Out',sep='/'))

pNames=c()
#Create paste names 
for(i in 1:nrow(Out)){
	pNames=c(pNames,paste(Out[i,1:3],collapse=''))
}

MatchVec=c()
#go through the pNames and find the one with the baseline measurement
for(p in 1:nrow(Out)){
	relPName=pNames[p]

	#intersect the names of which pNames=relPName and which is the current time point
	Int1=which(pNames==relPName)
	Int2=which(Out[,4]=='Pre')

	#intersect these to get relevant match
	relMatch=intersect(Int1,Int2)

	MatchVec=c(MatchVec,relMatch)
}

