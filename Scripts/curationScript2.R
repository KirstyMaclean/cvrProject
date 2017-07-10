#---------------------CURATION SCRIPT--------------------------#
#INPUT FILES: taxonData.txt AND curationcenter.txt AND completedata.txt
#OUTPUT FILES: Center.txt and completedata.txt 

#install required libraries
library('plyr')


d<- read.csv("completedata.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"),encoding="UTF-8")

#read in new file with NCBI taxonomy's scientific name and merge with Organism column *subject to change.
taxMerg1<-read.csv("taxonData.txt",header=TRUE, na.strings=c("NA", "", "n/a"))
#print(names(taxMerg1))
#print(names(d))
d2 <- merge(d, taxMerg1, by.x='TaxID', by.y= 'Taxonomic.ID')
print(names(d2))


#testing counts
OrganismcountTest <- count(d$Organism)
Organismcount <- count(d2$NCBI.Scientific.Name)
CommonName <-count(d2$Common.Name)

#location curation# 

#use google api, google map services python or r google map making - mondays job.
Center <- d2$Center
#print(d2$Center)

CenterCount <-count(Center)
#Curation for top 100, will go back later if time permits.
d2$Center <- sub("BI", "Broad Institute, MA 02142", d2$Center)
d2$Center <- sub("Broad Institute", "Broad Institute, MA 02142", d2$Center)
d2$Center <- sub("EMBL-EBroad Institute, MA 02142", "Enteric Disease Laboratory Branch", d2$Center)
d2$Center <- sub("edlb-cdc", "Enteric Disease Laboratory Branch", d2$Center)
d2$Center <- sub("EDLB-CDC", "Enteric Disease Laboratory Branch", d2$Center)
d2$Center <- sub("UCSD", "University of California San Diego", d2$Center)
d2$Center <-sub("BGI", "Beijing Genome Institute", d2$Center)
d2$Center <- sub("UMIGS", "University of Maryland Institute for Genomic Sciences", d2$Center)
d2$Center <- sub("CCME-COLORADO", "Colorado Center of Medical Excellence", d2$Center)
d2$Center <- sub("IBSC", "International Barley Sequencing Consortium, US, Germany, UK, Finland, Australia and Japan", d2$Center)
d2$Center <- sub("USC", "University of Southern California", d2$Center)
d2$Center <- sub("INRA", "French National Institute for Agricultural Research",d2$Center)
d2$Center <- sub("OSAKAMED", "Osaka Medical School", d2$Center)
d2$Center <- sub("PHE", "Public Health England, SE1 8UG", d2$Center)
d2$Center <- sub("Texas A&amp;M University", "Texas A&M Univiersity", d2$Center)
d2$Center <- sub ("MSKCC", "Memorial Sloan Kettering Cancer Center, 1275 York Avenue, New York, NY 10065", d2$Center)
d2$Center <- sub("UWGS-RW", "university of washington genome sciences", d2$Center)
d2$Center <- sub ("IMPLAD", "Chinese academy of medical sciences IMPLAD", d2$Center)
d2$Center <- sub("Northwest A&amp;F University", "Northwest A&F University", d2$Center)
d2$Center <- sub("CGS-GL", "Genomics and Pathology Services - Washington University School of Medicine in St. Louis", d2$Center)
d2$Center <- sub("CSIRO", "Commonwealth Scientific and Industrial Research Organisation", d2$Center)
d2$Center <-sub("KYOTO-HE", "Kyoto University, Japan", d2$Center)
d2$Center <- sub("KYOTO_HE", "Kyoto Unviersity, Japan", d2$Center)
d2$Center <- sub("RIKEN_OSC", "RIKEN Yokohama Institute Yokohama Research Promotion Division", d2$Center)
d2$Center <- sub("Nutrition &amp; Health", "Nutrition & Health", d2$Center)

#d2$Center <- str_replace_all(d2$Center,"é", "e")


Center <- d2$Center

CenterCount <-count(Center)
#saving to file, to run via R script ggmaps to find co-ords from google maps.
d2UniCenter <- c(unique(d2$Center))
d2UniCenter <- na.omit(d2UniCenter)

#writing all unique centers to a txt file.
write(d2UniCenter, file="Center.txt", sep = "\n")



write.table(d2, "completedata.txt", sep="\t", row.names=FALSE)



