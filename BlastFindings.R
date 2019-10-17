BlastFindings<- function(reference_Genome,significatGenes)
{
  install.packages("devtools")
  library(devtools)
  install_git("https://git.bioconductor.org/packages/genbankr")
  library(genbankr)
  #source('https://bioconductor.org/biocLite.R')
  #BiocManager::install("BiocUpgrade")
  BiocManager::install(c("GenomicFeatures", "AnnotationDbi"))
  library("Biostrings")
  library(bio3d)
  #----------------------------instruction -----------------------------------#
  #                                                                           #
  #     first need to downlaod the sequence.gb (full) from NCBI               #
  #                                                                           #
  #---------------------------------------------------------------------------#
  #-----------------------read significant genes ------------------------------------------#
  sig.rownames<-rownames(significatGenes)
  rownames(reference_Genome)<- reference_Genome[,4]
  significatns<-reference_Genome[sig.rownames,]
  significatns<-significatns[,2:4]
  colname<- c("start","end","gene.name")
  colnames(significatns)<-colname
  
  #-----------------------------read protein translations ----------------------------------#
  gb = readGenBank("./input/sequence.gbk")
  tr <- transcripts(gb)
  proteins <- mcols(tr)[,c(2,7)]
  for(i in 1:nrow(proteins))
  {
    for (j in 1:nrow(significatGenes))
    {
      if (as.character(proteins[i,1]== significatns[j,3] ))
      {
        seq<- as.character(proteins[i,2])
        #--------------------------- read BLAST ---------------------------------#
        Hit<- blast.pdb(seq, database = "pdb", time.out = NULL, chain.single=TRUE)
        write.csv(x= Hit$hit.tbl,file = paste("./output/hits/",paste(c(as.character(proteins[i,1])),".csv",sep=""),sep=""))
        break(j)
      }
    }
    print(i)
  }
}
