Filters<- function(pblast.hits)
{
  match.structures<- NULL
  for (i in 1:length(pblast.hits))
  { 
    inputs <- as.matrix(read.table(paste("./output/hits/",pblast.hits[i],sep=""),header=T,sep=",",stringsAsFactors = F))
    
    for (j in 1: nrow(inputs))
    {
      if ((as.integer(inputs[j,4])>=90)&(as.integer(inputs[j,12])<=0.0000000000001)) 
      {
        inputs[j,1]<- c(pblast.hits[i])
        x<- c(inputs[j,])
        x<- gsub(pattern = ".csv",replacement = "",x, perl = T)
        
        match.structures<-rbind(match.structures,x)
      }
    }
  }
  return(match.structures)
}
