argv <- commandArgs(trailingOnly = TRUE)
sourcePath <- argv[1]
bedpath <- argv[2]
intersectionspath <- argv[3]
inputFiles <- argv[4]
bigtableFile <- argv[5]
bigtableWeightFile<-argv[6]
SignificatGenes<-argv[7]

source(paste0(sourcePath,"/source/Inputs.R"))
source(paste0(sourcePath,"/source/permutationTest.R"))
source(paste0(sourcePath,"/source/BlastFindings.R"))
source(paste0(sourcePath,"/source/MutationPosition.R"))
source(paste0(sourcePath,"/source/GenePosition.R"))
source(paste0(sourcePath,"/source/Filters.R"))
source(paste0(sourcePath,"/source/FisherTest.R"))


#-----------------------------------------------------------------------#
#                             read bedfiles                             #
#-----------------------------------------------------------------------#
reference_Genome <- as.matrix(read.table(paste0(bedpath,"/nctc8325-1.bed"),header=F,sep="\t",stringsAsFactors = F))
length.genome <- nrow(reference_Genome)
intersections<- list.files(intersectionspath)
gene.length<- as.numeric(reference_Genome[,3]) - as.numeric(reference_Genome[,2])
reference_Genome<-cbind(reference_Genome,gene.length)
#-----------------------------------------------------------------------#
#            calculate number of mutations per each gene                #
#-----------------------------------------------------------------------#
bigtable <- matrix(0,nrow=length(reference_Genome[,4]),ncol=length(intersections))
rownames(bigtable) <- reference_Genome[,4]
colnames(bigtable) <- intersections
bigtable.norm<-bigtable
for (i in 1:length(intersections))
{
  res <- intesect_reference_vcf(intersections[i],reference_Genome,intersectionspath)
  if(names(res) != ".") {
  bigtable[names(res),i] <-  as.numeric(res) 
  bigtable.norm[names(res),i] <-  as.numeric(res) / as.numeric(reference_Genome[i,10])
}}
bigtable <- bigtable[rowSums(bigtable)!= 0,]
bigtable.norm <- bigtable.norm[rowSums(bigtable.norm)!= 0,]
#-------------------------------------------------------------------------#
#            save genes that have mutation in isolates                    #
#-------------------------------------------------------------------------#
write.csv(bigtable,bigtableFile)
write.csv(bigtable.norm,bigtableWeightFile)
#-------------------------------------------------------------------------#
#             find significant genes by permutation test                  #
#-------------------------------------------------------------------------#
significatGenes<-permutationTest(bigtable.norm,Resisdant,Suseptible)
write.csv(significatGenes,SignificatGenes)
