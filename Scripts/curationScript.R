#---------------------CURATION SCRIPT--------------------------#
#install required libraries
library('plyr')

#read in .txt file downloaded from SRA
d<- read.csv("sra_shinydata.txt", header=TRUE, sep="\t", quote= "", na.strings=c("NA", "", "n/a"))


#curation of the platform's (models)
d$Model <- sub("454.*", "454 GS", d$Model)
d$Model <- sub("AB 3.*", "AB GA", d$Model)
d$Model <- sub("AB 5.*", "AB GA", d$Model)
d$Model <- sub("AB S.*", "AB SOLiD", d$Model)
d$Model <- sub("Illumina G.*", "Illumina GA", d$Model)
d$Model <- sub("Illumina Hi.*", "Illumina HiSeq", d$Model)
d$Model <- sub("HiSeq X.*", "Illumina HiSeq", d$Model)
d$Model <- sub("Illumina Mi.*", "Illumina MiSeq", d$Model)
d$Model <- sub("Illumina NextSeq.*", "Illumina NextSeq", d$Model)
d$Model <- sub("NextSeq 5.*", "Illumina NextSeq", d$Model)
d$Model <- sub("PacBio.*", "PacBio RS", d$Model)
d$Model <- sub("Sequel.*", "PacBio RS", d$Model)
d$Model <- sub("Ion.*", "Ion Torrent", d$Model)
d$Model <- sub("Complete.*", "BGISEQ-500", d$Model)
d$Model[d$Model == 'NA'] <- NA
d$Model[d$Model == 'unspecified'] <- NA

#make sure it is effective
model <- d$Model
modelCount <- count(d$Model)

#curation of date into year
#date curation
d$Date <- as.Date(d$Date)
d$Date <- as.numeric(format(d$Date, "%Y"))
d$Date <- as.factor(d$Date)
dateCount <- count(d$Date)

#organism name curation from NCBI taxonomy due to poor sra reliability.
dfUniTax <- c(unique(d$TaxID))
dfUniTax <- na.omit(dfUniTax)

#writing all taxonomic ID's to txt
write(dfUniTax, file="TaxID.txt", sep = "\n")

##run perl script TaxID.pl *subject to name change.

#read in new file with NCBI taxonomy's scientific name and merge with Organism column *subject to change.
taxMerg<-read.csv("NCBItaxID.txt",header=TRUE, sep="\t", 
                  quote = "", na.strings = c("", "NA", "n/a"))
d <- merge(d, taxMerg, by.x = "Organism", by.y = "NCBI.Scientific.Name")
d <- merge(d, taxMerg)
Organismcount <- count(d$Organism)


#addition of Lineage and organism common name#
#WORKING PROGRESS# -fix script monday.

#library selection curation
d$LibrarySelection <- sub("other", "OTHER", d$LibrarySelection)
d$LibrarySelection <- sub("repeat fractionation", "Fractionation", d$LibrarySelection)
d$LibrarySelection <- sub("size fractionation", "Fractionation", d$LibrarySelection)
d$LibrarySelection <- sub("RANDOM", "RANDOM PCR", d$LibrarySelection)
d$LibrarySelection <- sub("PCR", "RT-PCR", d$LibrarySelection)
#location curation# 
#WORKING PROGRESS#
#use google api, google map services python or r google map making - mondays job.
Center <- d$Center
CenterCount <-count(Center)
