MutationPosition<- function(reference_Genome,inputs)
{
  for (i in 1:length(inputs))
  {
    intersections <- read.table(paste("./input/intersections/",inputs[i],sep=""),header=F,sep="\t",stringsAsFactors = F)
    length.intersection= nrow(intersections)
    for (j in 1 :length.genome)
    { 
      for (k in 1:length.intersection) 
      {
        if (intersections[k,2] >= reference_Genome[j,2] & intersections[k,2] <= reference_Genome[j,3]) 
        { 
          intersections[k,1] = reference_Genome [j,4]
          intersections[k,3] = reference_Genome [j,2]
          intersections[k,4] = reference_Genome [j,3]
        }
      }
    }
    inputs[i]<- gsub(pattern = "_q5000_dp250.bed",replacement = "",inputs[i], perl = T)
    inputs[i]<- gsub(pattern = "intersect-",replacement = "",inputs[i], perl = T)
    write.csv(x=intersections,file = paste("./output/VariantPosition/",paste(inputs[i],".csv"),sep=""))
  }
}
  
