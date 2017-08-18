#---------------------MERGE SCRIPT--------------------------#

#A script that merges the results from fetchGeocode.R, fetchTaxID.pl and dataCuration.R

#INPUT FILES: data.txt, center_Geocoded.csv, taxonData.txt

#OUTPUT FILES: completeData.txt

#install libraries
library('dplyr')
library('base')

#read in newest data, fetchGeocode data and fetchTaxID data.
d<- read.csv("data.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))
geoMerge <- read.csv ("geocoded.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))
taxMerg <- read.csv("taxonData.txt",header=TRUE, sep=",", na.strings=c("NA", "", "n/a"))

#Getting rid of unwanted columns
#main data
cols.dont.want <- c("bioProj", "bioSample", "LibraryName", "Laboratory", "ContactName", "UpdateDate", "Design", "Description") 
d <- d[, ! names(d) %in% cols.dont.want, drop = F]

#geocode data
cols.dont.want <- "accuracy"
geoMerge <- geoMerge[, ! names(geoMerge) %in% cols.dont.want, drop= F]
typeof(geoMerge)

#taxonomy data
cols.dont.want <- c("Subspecies", "Genus", "Species")
taxMerg <- taxMerg[, ! names(taxMerg) %in% cols.dont.want, drop= F]
typeof(taxMerg)
taxMerg <-na.omit(taxMerg)

#merging three files together
d2 <- merge(d, taxMerg, by.x='TaxID', by.y ='Taxonomic.ID', all.x=TRUE)
 d3 <- merge(d2, geoMerge, by.x="Center", by.y= 'V1', all.x = TRUE)

#read in previously curated data and bind with newest
d4<- read.csv("completeData.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))
d5 <- rbind(d3, d4)

#final data file for application
write.csv(d5, "completeData.txt", sep=",", row.names=FALSE, quote=TRUE)
