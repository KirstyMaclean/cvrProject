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
taxMerg1<-read.csv("taxonData.txt",header=TRUE, sep=",", 
                  quote = "")
d2 <- merge(d, taxMerg1, by.x='TaxID', by.y= 'Taxonomic.ID')
#testing counts
OrganismcountTest <- count(d$Organism)
Organismcount <- count(d2$NCBI.Scientific.Name)
CommonName <-count(d2$Common.Name)

#working with data frame d2 from here onwards.#
#library selection curation
d2$LibrarySelection <- sub("other", "OTHER", d$LibrarySelection)
d2$LibrarySelection <- sub("repeat fractionation", "Fractionation", d$LibrarySelection)
d2$LibrarySelection <- sub("size fractionation", "Fractionation", d$LibrarySelection)
d2$LibrarySelection <- sub("RANDOM", "RANDOM PCR", d$LibrarySelection)
d2$LibrarySelection <- sub("PCR", "RT-PCR", d$LibrarySelection)
#location curation# 

#use google api, google map services python or r google map making - mondays job.
Center <- d2$Center
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
d2$Center <- sub("INRA", "French National Institute for Agricultural Research")
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

Center <- d2$Center
CenterCount <-count(Center)

#saving to file, to run via python script to find co-ords from google maps.
d2UniCenter <- c(unique(d2$Center))
d2UniCenter <- na.omit(d2UniCenter)

#writing all unique centers to a txt file.
write(d2UniCenter, file="Center.txt", sep = "\n")

#API KEY: AIzaSyBYaJsyYCIBTVs4muXY_04SGhKV4oWfAME


#curation of design and description, removing unwanted punctuation
d2$Description <- str_replace_all(d2$Description,"_"," ")
d2$Design <- str_replace_all(d2$Design, "-", " ")
