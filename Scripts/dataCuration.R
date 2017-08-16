#---------------------CURATION SCRIPT--------------------------#

#INPUT FILES: sra_shinydata.txt

#OUTPUT FILES: Center.txt, taxID.txt and data.txt

#install required libraries

library('plyr')
library('base')

#Read in large data file from Sequence Read Archive
d<- read.csv("sra_weekly.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))

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
d$Model[d$Model =="NA"] <- NA
d$Model[d$Model == "unspecified"] <- NA

#make sure it is effective
model <- d$Model
modelCount <- count(d$Model)

#curation of date into year
#date curation
d$Date <- as.Date(d$Date)
d$Date <- as.numeric(format(d$Date, "%Y"))
d$Date <- as.factor(d$Date)
dateCount <- count(d$Date)

#working with data frame d from here onwards.#
#library selection curation
d$LibrarySelection <- sub("other", "OTHER", d$LibrarySelection)
d$LibrarySelection <- sub("repeat fractionation", "Fractionation", d$LibrarySelection)
d$LibrarySelection <- sub("size fractionation", "Fractionation", d$LibrarySelection)
d$LibrarySelection <- sub("RANDOM", "RANDOM PCR", d$LibrarySelection)
d$LibrarySelection <- sub("PCR", "RT-PCR", d$LibrarySelection)

#curation of design and description, removing unwanted punctuation
d$Description <- sub("_"," ",d$Description)
d$Design <- sub("_", " ", d$Design)


#organism name curation from NCBI taxonomy due to poor sra reliability.
dfUniTax <- c(unique(d$TaxID))
dfUniTax <- na.omit(dfUniTax)

#location curation# 
#Curation for top 100, will go back later if time permits.

typeof(d$Center)
d$Center <- as.character(d$Center)

#replaces any ascii characters to there english counterpart
d$Center <- iconv(d$Center, to='ASCII//TRANSLIT')


d$Center<- replace(d$Center, d$Center=="BI", "Broad Institute")
d$Center<- replace(d$Center, d$Center=="UMIGS", "University of Maryland Institute for Genomic Sciences")
d$Center<- replace(d$Center, d$Center=="edlb-cdc", "Enteric Disease Laboratory Branch")
d$Center<- replace(d$Center, d$Center=="EDLB-CDC", "Enteric Disease Laboratory Branch")
d$Center<- replace(d$Center, d$Center=="KYOTO-HE", "Kyoto University, Japan")
d$Center<- replace(d$Center, d$Center=="KYOTO_HE", "Kyoto University, Japan")
d$Center<- replace(d$Center, d$Center=="KYOTO-HE", "Kyoto University, Japan")
d$Center<- replace(d$Center, d$Center=="RIKEN_OSC", "RIKEN Yokohama Institute Yokohama Research Promotion Division")
d$Center<- replace(d$Center, d$Center=="CSIRO", "Commonwealth Scientific and Industrial Research Organisation")
d$Center<- replace(d$Center, d$Center=="CGS-GL", "Genomics and Pathology Services - Washington University School of Medicine in St. Louis")
d$Center<- replace(d$Center, d$Center=="IMPLAD", "Chinese academy of medical sciences IMPLAD")
d$Center<- replace(d$Center, d$Center=="UWGS-RW", "university of washington genome sciences")
d$Center<- replace(d$Center, d$Center=="MSKCC", "Memorial Sloan Kettering Cancer Center, 1275 York Avenue, New York, NY 10065")
d$Center<- replace(d$Center, d$Center=="OSAKAMED", "Osaka Medical School")
d$Center<- replace(d$Center, d$Center=="INRA", "French National Institute for Agricultural Research")
d$Center<- replace(d$Center, d$Center=="USC", "University of Southern California")
d$Center<- replace(d$Center, d$Center=="IBSC", "International Barley Sequencing Consortium, US, Germany, UK, Finland, Australia and Japan")
d$Center<- replace(d$Center, d$Center=="CCME-COLORADO", "Colorado Center of Medical Excellence")
d$Center<- replace(d$Center, d$Center=="UMIGS", "University of Maryland Institute for Genomic Sciences")
d$Center<- replace(d$Center, d$Center=="BGI", "Beijing Genome Institute")
d$Center<- replace(d$Center, d$Center=="UCSD", "University of California San Diego")
d$Center<- sub("&amp;", " & ", d$Center)
d$Center<- sub("-", " ", d$Center)
d$Center<- sub("_", " ", d$Center)

Center <- d$Center
typeof(Center)
Center <- as.data.frame(Center)
CenterCount <-count(Center)

dUniCenter <- c(unique(d$Center))
dUniCenter <- na.omit(dUniCenter)

 
#-----Writing out to txt files-------#

#unique centers for geolocations
write(dUniCenter, file="Center.txt", sep = "\n")

#unique taxonomic ID's for Taxonomy database parsing
write(dfUniTax, file="TaxID.txt", sep = "\n")

#table with all the curation data
write.table(d, "data.txt", sep="\t", row.names=FALSE)

