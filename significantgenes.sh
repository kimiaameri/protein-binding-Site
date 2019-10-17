#!/bin/sh
#SBATCH --time=80:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=16384     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=significantgenes
#SBATCH --error=significantgenes.%J.err
#SBATCH --output=significantgenes.%J.out
cd $WORK/SNP-outputs/
mkdir vcfbed
mkdir intersection
cd $WORK/SANVA/
python3 GenomeBedPull.py $WORK/SNP_reference_genome 
export GENOME_BED_PATH="$WORK/SNP_reference_genome/"
python3 pythonVcfbed.py ./InputFiles.csv $MINICONDA_HOME
sh vcfBed.sh
python3 pythonIntersections.py ./InputFiles.csv $GENOME_BED_PATH $MINICONDA_HOME
sh mapVCF-to-Bed.sh

export INTERSECTIONS_PATH="$WORK/SNP-outputs/intersection/"
export OUTPUT_PATH="$WORK/SNP-outputs/"


cd $WORK/SNP-outputs
export SOURCE_DIR="$WORK/SNP"

cd $WORK/SANVA_reference_genome
cat  nctc8325.bed | tail -n+2 > nctc8325-1.bed 
cd $WORK/SANVA/     
Rscript maincode.R $SOURCE_DIR $GENOME_BED_PATH $INTERSECTIONS_PATH ./InputFiles.csv bigtable.csv tableWeight.csv significantGenes.csv
mv bigtable.csv $OUTPUT_PATH/
mv significantGenes.csv $OUTPUT_PATH/
