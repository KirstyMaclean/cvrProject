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

#organism name curation
Organismcount <- count(d$Organism)

d$Organism<-sub("9606", "Homo sapiens", d$Organism)
d$Organism<-sub("10090", "Mus musculus", d$Organism)
d$Organism<-sub("4530", "Oryza sativa", d$Organism)
d$Organism<-sub("112509", "Hordeum vulgare subsp. vulgare", d$Organism)
