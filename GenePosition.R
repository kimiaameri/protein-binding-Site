GenePosition<- function(reference_Genome,inputs,match.structures)
{
  z<- NULL
  mutation.pos<-NULL
  ids <- unique(match.structures[,1])
  gene.ids <- reference_Genome[as.character(ids),]
  for (i in 1:length(inputs))
  {
    input<- read.table(paste("./output/VariantPosition/",inputs[i],sep=""),header=T,sep=",",stringsAsFactors = F)
    z<-append(z,intersect(input[,2],gene.ids[,4]))
    for (j in 1:length(z)) mutation.pos<-rbind(mutation.pos,input[which(input[,2]==z[j]),c(2:5,7:8)])
  }
  mutation.pos.name<- c("gene.ids","mutation","gene.start","gene.end","ref","alt")
  colnames(mutation.pos) <- mutation.pos.name
  info<-NULL
  k=0
  matches<- matrix(NA, nrow = 1, ncol = 3)
  for (i in 1:nrow(mutation.pos))
  { 
    for (j in 1:nrow(match.structures))
    {
      if (mutation.pos[i,1]==match.structures[j,1]) 
      {
        k=k+1
        matches[1,]<-match.structures[j,c(1,18,19)]
        p<-cbind(matches,mutation.pos[i,(2:6)])
        x<- as.numeric(p[,4])-as.numeric(p[,5])
        gene.lenth<- as.numeric(p[,6])-as.numeric(p[,5])
        z<- round(abs(x-gene.lenth)/3)
        m.pos<- abs((gene.lenth/3)-z)
        p<- cbind(p,m.pos)
        info<- rbind(info, p)
        info[k,1]<- as.character(p[,1])
        info[k,2]<-  as.character(p[,2])
        info[k,3]<-  as.character(p[,3])
        p <- NULL
      }
    }
  }
  final.information<- unique(info)
  write(pdb.ids,sep = ",",file = "./output/pdbid.csv")
  write.csv(final.information,file = "./output/final_information.csv")
  return(final.information)
}
  
