#SCRIPT TO CATALOG DATA FROM SRA#

#setting working directory and installing libraries/packages
setwd("~/CVR_Project/")
library("ggplot2")
library("plyr")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

#Reading in .txt file into a table in R.

d <- read.csv("sraDATA.txt", header=TRUE, sep="\t", quote = "", na.strings=c("NA", "", "n/a"))


#-----------------------Company Bar Graph------------------------------------------------------#
#redefine as factor
d$Platform <- as.factor(d$Platform)


#Create platform variable from levels for plot
platforms <- levels(d$Platform)

#Total count of each platform ordered
countPlatform = count(d, 'Platform')
countPlatform <- countPlatform[order(-countPlatform$freq),]

#No. rows from platCounts df, necessary for barplot
rowsX <- nrow(countPlatform)

#Build dataframe for barplot
len = countPlatform[2]
dose=countPlatform[1]
df <- data.frame(dose=countPlatform[1],
                 len=countPlatform[2])
df$Platform <- droplevels(df$Platform)

df$platform<- reorder(df$Platform, -df$freq)

#Change x axis labels (will be fixed further later)
x = 1
xLabs <- seq(x,rowsX,1)
xLabs <- toString(xLabs)
xLabs <- strsplit(xLabs,",")

#Create platforms barplot

p<-ggplot(data=df, aes(x=df$Platform, y=len)) +
  geom_bar(aes(fill=platform),stat="identity")+ scale_y_log10() +
  scale_x_discrete(labels=xLabs)

#Add labels
p <- p + labs(x = "Company")
p <- p + labs(y = "Count (log10)")
p <- p + labs(title = "Company Dataset Frequency in SRA")
p <- p + labs(colour = "Company") 
p

#Save as PDF
ggsave(p,file='Companyplot.pdf', width = 16, height = 9, dpi = 120)
dev.off()



#--------------------Number of Datasets Submitted to SRA vs Platform Used---------------------#
#curation of models
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


#redefine as factor
d$Model <- as.factor(d$Model)


#Create platform variable from levels for plot
platforms <- levels(d$Model)

#Total count of each platform ordered
countPlatform = count(d, 'Model')
countPlatform <- countPlatform[order(-countPlatform$freq),]

#No. rows from platCounts df, necessary for barplot
rowsX <- nrow(countPlatform)

#Build dataframe for barplot
len = countPlatform[2]
dose=countPlatform[1]
df <- data.frame(dose=countPlatform[1],
                 len=countPlatform[2])
df$Model <- droplevels(df$Model)

df$Model<- reorder(df$Model, -df$freq)

#Change x axis labels (will be fixed further later)
x = 1
xLabs <- seq(x,rowsX,1)
xLabs <- toString(xLabs)
xLabs <- strsplit(xLabs,",")

#Create platforms barplot

p<-ggplot(data=df, aes(x=df$Model, y=len)) +
  geom_bar(aes(fill=Model),stat="identity")+ scale_y_log10() +
  scale_x_discrete(labels=xLabs)

#Add labels
p <- p + labs(x = "Platform")
p <- p + labs(y = "Count (log10)")
p <- p + labs(title = "Platform Model Dataset Frequency in SRA")
p <- p + labs(colour = "Platforms") 
p

#Save as PDF
ggsave(p,file='PlatformPlot3.pdf', width = 16, height = 9, dpi = 120)
dev.off()


#----------line graph for number of bases sequence by each model on average.------------------#
#Return bases sequenced each year for each platform
#date curation
d$Date <- as.Date(d$Date)
d$Date <- as.numeric(format(d$Date, "%Y"))
d$Date <- as.factor(d$Date)

#Subsetted df to be used
dLine <- d[c(-1,-2,-3,-5,-6,-9,-10,-11,-12)]

#Print total bases for each platform for each year & platform separately
#HiSeq

 for  (i in 2007:2017)

  {
    hSeq<- dLine[ which(dLine$Date  == i & dLine$Model == "Illumina HiSeq"),]
    print(sum(hSeq$Bases))    
 }
#MiSeq
for  (i in 2007:2017)
  
{
  MiSeq<- dLine[ which(dLine$Date  == i & dLine$Model == "Illumina MiSeq"),]
  print(sum(MiSeq$Bases))    
}
#454 GS
for  (i in 2007:2017)
  
{
  GS<- dLine[ which(dLine$Date  == i & dLine$Model == "454 GS"),]
  print(sum(GS$Bases))    
}
#Illumina GA
for  (i in 2007:2017)
  
{
  IllGA<- dLine[ which(dLine$Date  == i & dLine$Model == "Illumina GA"),]
  print(sum(IllGA$Bases))    
}
#Illumina NextSeq
for  (i in 2007:2017)
  
{
  nextSeq<- dLine[ which(dLine$Date  == i & dLine$Model == "Illumina NextSeq"),]
  print(sum(nextSeq$Bases))    
}
#Ion Torrent
for  (i in 2007:2017)
{
  iTorr<- dLine[ which(dLine$Date  == i & dLine$Model == "Ion Torrent"),]
  print(sum(iTorr$Bases))    
}
#PacBio RS
for  (i in 2007:2017)
{
  pacBio<- dLine[ which(dLine$Date  == i & dLine$Model == "PacBio RS"),]
  print(sum(pacBio$Bases))    
}
#AB SoLiD
for  (i in 2007:2017)
{
  solid<- dLine[ which(dLine$Date  == i & dLine$Model == "AB SOLiD"),]
  print(sum(solid$Bases))    
}
#AB GA
for  (i in 2007:2017)
{
  GA<- dLine[ which(dLine$Date  == i & dLine$Model == "AB GA"),]
  print(sum(GA$Bases))    
}
#Helicos HeliScope
for  (i in 2007:2017)
{
  heH<- dLine[ which(dLine$Date  == i & dLine$Model == "Helicos HeliScope"),]
  print(sum(heH$Bases))    
}
#BGISEQ500
for  (i in 2007:2017)
{
  BGI<- dLine[ which(dLine$Date  == i & dLine$Model == "BGISEQ-500"),]
  print(sum(BGI$Bases))    
}
#minION
miniI <- for  (i in 2007:2017)
{
  minI<- dLine[ which(dLine$Date  == i & dLine$Model == "MinION"),]
  
}

HiSeq <- c(0,0,0,217778549036,1.156241e+13,9.633261e+13,8.031178e+14,1.112222e+15,2.158814e+15,5.535639e+15,5.402476e+14)
MiSeq<- c(0,0,0,0,3092319638,1.08962e+11,3.047232e+12,1.123372e+13,2.693668e+13,3.79936e+13,3.28018e+13)
GS454<- c(0,863256191,701624451417,8.85767e+11,687539157228,659774318377,1.604169e+12,1.385147e+12,1.794931e+12,854683490950,375363438260)
illuminaGA<- c(0,16608590490,1.700967e+12,9.218384e+12,3.608042e+13,3.716721e+13,1.893878e+14,1.224394e+14,5.82108e+13,4.803834e+13,6.865253e+12)
nextSeq <- c(0,0,0,0,0,0,0,103881687879,2.336997e+13,7.248333e+13,2.748289e+13)
ionTorrent <- c(0,0,0,0,1282075675,74995552596,501663521884,1.365463e+12,4.108494e+12,5.794307e+12,1.909426e+12)
pacBio <- c(0,0,0,0,29125786423,70317629894,551629124607,1.997637e+12,1.043054e+13,1.446184e+13,3.583461e+12)
SOLiD <- c(0,7986711530,594071238223,1.538362e+12,1.945207e+13,6.399312e+12,2.212443e+13,1.112883e+13,3.500358e+12,5.879251e+12,353570891996)
AB<- c(0,0,0,0,0,1.20141e+12,4.591213e+12,4.353027e+12,5.505367e+12,2.240343e+12,741050788505)
Helicos <- c(0,0,164027920249,76964650180,85248831750,10575649444,423215681590,154105764294,55207902966,59034008201,2.425425e+12)
BGI <- c(0,0,0,0,2.282993e+12,2.877998e+14,4.833101e+14,1.068348e+13,4.759728e+13,8.598642e+12,3.448397e+13)
MinION <- c(0,0,0,0,0,0,0,12059560,17626772215,60788445988,76179156913)

list <- list(HiSeq, MiSeq, GS454, illuminaGA, nextSeq, ionTorrent, pacBio, SOLiD, AB, Helicos, BGI, MinION)

#Define new df with dimensions
lineDF <- data.frame(matrix(nrow = 1320, ncol = 3))
#Define column names of df
colnames(lineDF) <- c("Year", "Platform", "Bases")

#Paste bases list into bases column
lineDF$Bases = unlist(list)

#Create vector of platform names
platVecStr <- c("Illumina HiSeq","Illumina MiSeq","454 GS","Illumina GA","Illumina NextSeq","Ion Torrent",
                "PacBio","AB SOLID","AB GA","Helicos HeliScope","BGISEQ-500","MinION")

#Function to repeat platforms & unlist platform list into platforms column
platVecStr<-sapply(platVecStr, function (x) rep(x,11))
platVecStr <- as.vector(platVecStr)
listPlat <- list(platVecStr)

lineDF$Platform = unlist(listPlat)

#Create year vector
year = 2007
years <- seq(year,2017,1)
years <- toString(years)
years <- strsplit(years,",")

#Function to repeat years & unlist years list into years column
years<-sapply(years, function (x) rep(x,12))
years <- as.vector(years)
listYears <- list(years)
lineDF$Year = unlist(listYears)

#Reorder factors by year
lineDF$Year<- factor(lineDF$Year, levels=unique(as.character(lineDF$Year)) )

#Create Line Graph 
platBasePlot <- ggplot(data=lineDF, aes(x=lineDF$Year, y=lineDF$Bases, group=lineDF$Platform)) +
  geom_line(aes(color=lineDF$Platform))+ scale_y_log10() +
  geom_point(aes(color=lineDF$Platform))+theme_minimal()

#Labels
platBasePlot <- platBasePlot + labs(x = "Year")
platBasePlot <- platBasePlot + labs(y = "Bases (log10)")
platBasePlot <- platBasePlot + labs(title = "Number of Bases Sequenced by Each Platform between 2008:2017")
platBasePlot <- platBasePlot + labs(colour = "Platforms") 
platBasePlot


#Save plot
ggsave(platPlot,file='BasesPlot.pdf', width = 16, height = 9, dpi = 120)
#------------------------Count of the top 20 Organisms--------------------------------#
#curation human
d$Organism <- sub("human", "Human", d$Organism)
d$Organism <- sub("Homo sapiens", "Human", d$Organism)

#curation of Danio rerio
d$Organism <- sub("zebrafish", "Danio rerio", d$Organism)
d$Organism <- sub("Zebrafish", "Danio rerio", d$Organism)
d$Organism <- sub("male adult Danio rerio", "Danio rerio", d$Organism)

#curation of rice
d$Organism <- sub("Japanese rice", "rice", d$Organism)

#curation of mice (top 5 only)
d$Organism <- sub("house mouse", "mouse", d$Organism)
d$Organism <- sub("Mouse", "mouse", d$Organism)
d$Organism <- sub("Mus musculus", "mouse", d$Organism)
d$Organism <- sub("western European house mouse", "mouse", d$Organism)
d$Organism <- sub("eastern European house mouse", "mouse", d$Organism)
d$Organism <- sub("southeastern Asian house mouse", "mouse", d$Organism)
d$Organism <- sub("cactus mouse", "mouse", d$Organism)
d$Organism <- sub("M. musculus", "mouse",d$Organism)
d$Organism <- sub("m. musculus", "mouse",d$Organism)

#curation of Drosophila melanogaster (top 5)
d$Organism <- sub("fruit fly", "Drosophila melanogaster", d$Organism)
d$Organism <- sub("Fruit fly", "Drosophila melanogaster", d$Organism)
d$Organism <- sub("Mediterranean fruit fly", "Drosophila melanogaster", d$Organism)
d$Organism <- sub("oriental fruit fly", "Drosophila melanogaster", d$Organism)
d$Organism <- sub("fruitfly", "Drosophila melanogaster", d$Organism)

#curation of Thale Cress
d$Organism <- sub("thale cress", "Thale Cress",d$Organism)
d$Organism <- sub("arabidopsis thaliana", "Thale Cress",d$Organism)

#curation of pig
d$Organism <- sub("domestic pig", "pig", d$Organism)
d$Organism <- sub("Pig", "pig", d$Organism)
d$Organism <- sub("Sus scrofa", "pig", d$Organism)

#curation of cattle
d$Organism <- sub("Bos taurus", "cattle", d$Organism)
d$Organism <- sub("Cow", "cattle", d$Organism)
d$Organism <- sub("B taurus", "Cattle",d$Organism)
d$Organism <- sub("B. taurus", "Cattle",d$Organism)
d$Organism <- sub("Bos primigenius taurus", "Cattle",d$Organism)
d$Organism <- sub("B primigenius taurus", "Cattle",d$Organism)
d$Organism <- sub("B. primigenius taurus", "Cattle",d$Organis)

#curation of Epstein-Barr
d$Organism <- sub("human herpesvirus 4", "Epstein-Barr virus",d$Organism)
d$Organism <- sub("human herpesvirus-4", "Epstein-Barr virus",d$Organism)
d$Organism <- sub("HHV-4", "Epstein-Barr virus",d$Organism)
d$Organism<- sub("hhv-4", "Epstein-Barr virus",d$Organism)


#tables of different counts
organismCount <- d$Organism 
organismCount <-count(d, 'Organism')
organismCount <-organismCount[order(-organismCount$freq),]
Top20 <- organismCount[1:21,]
Top25 <-organismCount[1:26,]
Top200 <- organismCount[1:200,] #used for wordle

#------WordCloud examples -----#
#---most frequent words in Human
Human <- d[which(d$Organism=="Human"),]

#load data as a corpus
docs <- Corpus(VectorSource(Human$Description)) 
inspect(docs)
#text transformation
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
#cleaning the text
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("human", "study", "target", "sequence", "sequencing")) 
dtm <- TermDocumentMatrix(docs)
#Building a term-document matrix
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
#Generate a word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=500, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "PRGn"))
#finding frequent terms and their associations
findFreqTerms(dtm, lowfreq=100)
#plot word frequencies
barplot(d[1:10,]$freq, las = 2, 
        names.arg = d[1:10,]$word, log="y",
        col ="purple", main ="Most frequent words",
        ylab = "Word frequencies")

