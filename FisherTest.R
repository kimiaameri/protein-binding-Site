FisherTest<- function()
{
  Fisherinput<- as.matrix(read.table("./FisherTestInput.csv",header=T,sep=",",stringsAsFactors = F))
  Fisheroutput<- matrix(NA, nrow = 19,ncol = 4)
  for (i in 1:nrow(Fisherinput))
  {
    c<- matrix(as.numeric(c(Fisherinput[i,c(4:7)])),nrow = 2, byrow = F)
    test<-fisher.test(c)
    p_valu<-test$p.value
    Fisheroutput[i,1]<-Fisherinput[i,1]
    Fisheroutput[i,2]<-Fisherinput[i,2]
    Fisheroutput[i,3]<-Fisherinput[i,3]
    Fisheroutput[i,4]<-p_valu
  }
  return(Fisheroutput)
}
