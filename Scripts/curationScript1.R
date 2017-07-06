#---------------------CURATION SCRIPT--------------------------#
#install required libraries
library('plyr')
library('stringr')

#read in .txt file downloaded from SRA
#d<- read.csv("sra_shinydata.txt", header=TRUE, sep="\t", quote= "", na.strings=c("NA", "", "n/a"))
ud <-read.csv("newestdata.txt", header=TRUE, sep="\t", quote="", na.strings=c("NA", "", "n/a"))

#merge the large data file with newest update
#d1 <- rbind(d, ud)
d1 <- ud

#curation of the platform's (models)
d1$Model <- sub("454.*", "454 GS", d1$Model)
d1$Model <- sub("AB 3.*", "AB GA", d1$Model)
d1$Model <- sub("AB 5.*", "AB GA", d1$Model)
d1$Model <- sub("AB S.*", "AB SOLiD", d1$Model)
d1$Model <- sub("Illumina G.*", "Illumina GA", d1$Model)
d1$Model <- sub("Illumina Hi.*", "Illumina HiSeq", d1$Model)
d1$Model <- sub("HiSeq X.*", "Illumina HiSeq", d1$Model)
d1$Model <- sub("Illumina Mi.*", "Illumina MiSeq", d1$Model)
d1$Model <- sub("Illumina NextSeq.*", "Illumina NextSeq", d1$Model)
d1$Model <- sub("NextSeq 5.*", "Illumina NextSeq", d1$Model)
d1$Model <- sub("PacBio.*", "PacBio RS", d1$Model)
d1$Model <- sub("Sequel.*", "PacBio RS", d1$Model)
d1$Model <- sub("Ion.*", "Ion Torrent", d1$Model)
d1$Model <- sub("Complete.*", "BGISEQ-500", d1$Model)
d1$Model[d1$Model == 'NA'] <- NA
d1$Model[d1$Model == 'unspecified'] <- NA

#make sure it is effective
model <- d1$Model
modelCount <- count(d1$Model)

#curation of date into year
#date curation
d1$Date <- as.Date(d1$Date)
d1$Date <- as.numeric(format(d1$Date, "%Y"))
d1$Date <- as.factor(d1$Date)
dateCount <- count(d1$Date)

#working with data frame d2 from here onwards.#
#library selection curation
d1$LibrarySelection <- sub("other", "OTHER", d1$LibrarySelection)
d1$LibrarySelection <- sub("repeat fractionation", "Fractionation", d1$LibrarySelection)
d1$LibrarySelection <- sub("size fractionation", "Fractionation", d1$LibrarySelection)
d1$LibrarySelection <- sub("RANDOM", "RANDOM PCR", d1$LibrarySelection)
d1$LibrarySelection <- sub("PCR", "RT-PCR", d1$LibrarySelection)

#curation of design and description, removing unwanted punctuation
d1$Description <- str_replace_all(d1$Description,"_"," ")
d1$Design <- str_replace_all(d1$Design, "-", " ")

#write to txt file to add in to script later on.
write.table(d1, "completedata.txt", sep="\t", row.names = FALSE)

#organism name curation from NCBI taxonomy due to poor sra reliability.
dfUniTax <- c(unique(d1$TaxID))
dfUniTax <- na.omit(dfUniTax)

#writing all taxonomic ID's to txt
write(dfUniTax, file="TaxID.txt", sep = "\n")



