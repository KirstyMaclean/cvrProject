#SCRIPT 3: Merge of Center's and Writing out to file
library('dplyr')

d<- read.csv("completedata.txt", header=TRUE, sep="\t", quote= "", na.strings=c("NA", "", "n/a"))
cn <- read.csv ("ggmap.txt", header=TRUE, sep=",", quote = "", na.strings=c("NA", "", "n/a"))

d3 <- merge(d, cn, by.x='Center', by.y= 'Center')

#read in previously curated data and bind with newest
d<- read.csv("sra_shinydata.txt", header=TRUE, sep="\t", quote= "", na.strings=c("NA", "", "n/a"))
d3 <- rbind(d, d3)

#remove duplicates
d3 <- distinct(d3, d$ID)

#final data file for application
write.table(d3, "ShinyData.txt", sep="\t", row.names=TRUE)
