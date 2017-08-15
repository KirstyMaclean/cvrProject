# server.R
#installing appropriate libraries
library(shiny)
library(shinythemes)
library(maps)
library(mapproj)
library(ggplot2)
library(gridExtra)
library(ape)
library(wordcloud)
library(tm)
library(RColorBrewer)
library(plyr)
library(scales)
library(lattice)

#gathering all information requred
data <- read.csv("ShinyData.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))
longlat <- data[c(1,28,29)]

shinyServer(
  #function's for plot(s) on overview page.
function(input, output) {
  dateUniq <- unique(data$Date)
  dateUniq <- as.list(dateUniq)
  libUniq <-unique(data$LibrarySource)
  libUniq <- as.list(libUniq)
  
  comp = function(){    
    #can correlate all data here.
    data$Company <- as.factor((data$Company))
    Company <- levels(data$Company)
    countCompany<- count(data$Company)
   
    countCompany <- countCompany[order(-countCompany$freq),]
    
  #No. rows from platCounts df, necessary for barplot
    rowsX <- nrow(countCompany)
    
    #Build dataframe for barplot
    Freq = countCompany[2]
    dose=countCompany[1]
    df <- data.frame(dose=countCompany[1],
                     Freq=countCompany[2])
    # df$Company <- droplevels(df$Company)
    
    Company<- reorder(df$x, -df$freq)
    
    #Change x axis labels (will be fixed further later)
    x = 1
    xLabs <- seq(x,rowsX,1)
    xLabs <- toString(xLabs)
    xLabs <- strsplit(xLabs,",")
    
    #Create Companys barplot
    
    ggplot(data=df, aes(x=Company, y=Freq)) +
      geom_bar(aes(fill=Company),stat="identity")+ scale_y_log10() +
      scale_x_discrete(labels=xLabs)
    
  }
  
  output$company <- renderPlot({
    print(comp())
  })
    
  
  plat = function(){
    #can correlate all data here.
    data$Model <- as.factor((data$Model))
    platforms <- levels(data$Model)
    countPlatform = count(data$Model)
    countPlatform <- countPlatform[order(-countPlatform$freq),]
    
    #No. rows from platCounts df, necessary for barplot
    rowsX <- nrow(countPlatform)
    
    #Build dataframe for barplot
    Freq = countPlatform[2]
    dose=countPlatform[1]
    df <- data.frame(dose=countPlatform[1],
                     Freq=countPlatform[2])
    # df$Model <- droplevels(df$Model)
    
    Model<- reorder(df$x, -df$freq)
  
  #Change x axis labels (will be fixed further later)
  x = 1
  xLabs <- seq(x,rowsX,1)
  xLabs <- toString(xLabs)
  xLabs <- strsplit(xLabs,",")
  
  #Create platforms barplot
  
ggplot(data=df, aes(x=Model, y=Freq)) +
    geom_bar(aes(fill=Model),stat="identity")+ scale_y_log10() +
    scale_x_discrete(labels=xLabs)

}
 
     output$platform <- renderPlot({
       print(plat())
     })
organcount = function(){
  #organism counts datale
  orgCounts <- count(data, 'Common.Name')
  orgCounts <- na.omit(orgCounts)
  
  #Order orgCounts df
  orgCounts <- orgCounts[order(-orgCounts$freq),]
  
  #Truncate organism count datale to 20 organisms
  orgCounts <- orgCounts[1:20,]
  
  #Return organism levels & drop those not needed
  orgCounts$Common.Name <- droplevels(orgCounts$Common.Name)
  orgLev <- levels(orgCounts$Common.Name)
  
  #Count number of rows in df for organism plot
  rowsY <- nrow(orgCounts)
  
  #data frame plot setup
  dose = orgCounts[1]
  lenOrg = orgCounts[2]
  dfOrg <- data.frame(dose=orgCounts[1],
                      lenOrg=orgCounts[2])
  
  #Order levels for plot from greatest to least
  dfOrg$Common.Name <- droplevels(dfOrg$Common.Name)
  dfOrg$Common.Name <- reorder(dfOrg$Common.Name, -dfOrg$freq)
  
  
  orgCounts$Common.Name <- droplevels(orgCounts$Common.Name)
  orgCounts$Common.Name <- reorder(orgCounts$Common.Name, -orgCounts$freq)
  rownames(orgCounts) <- NULL
  
  #Creae 1-20 labels for plot
  xOrg = 1
  xLabsOrg <- seq(xOrg,rowsY,1)
  xLabsOrg <- toString(xLabsOrg)
  xLabsOrg <- strsplit(xLabsOrg,",")
  
  #Create organism plot
  pOrg<-ggplot(data=dfOrg, aes(x=dfOrg$Common.Name, y=lenOrg)) +
    geom_bar(aes(fill=dfOrg$Common.Name),stat="identity") + scale_y_log10() +
    scale_x_discrete(labels=xLabsOrg)
  
  #Add labels to plot
  pOrg <- pOrg + labs(x = "Organism")
  pOrg <- pOrg + labs(y = "Count (log10)")
  pOrg <- pOrg + guides(fill=guide_legend(title="Organisms"))
  pOrg
  

}
output$pOrg <- renderPlot({
  print(organcount())
})

bases = function(){
  dLine <- data[c(-1,-2,-3,-4,-5,-6,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30)]
  
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
  platBasePlot <- platBasePlot + labs(colour = "Platforms") 
  platBasePlot
  
}
output$base<- renderPlot({
  print(bases())
}) 

wcOrg = function(){
 
  terms <- reactive({
    terms <- data[c(12,23)]
    input$update
    isoloate({
      withProgress({
        setProgress(message= "Processing corpus...")
        getTermMatrix(input$comOrg)
      })
    })
  })
  comOrganism <- unique(com.org$Common.Name)
  comOrganism<- as.list(comOrganism)
  
  text <- terms$Description
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "the", "and", "a", "to", "of", "in"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
  
  wordcloud_rep <- repeatable(wordcloud)
} 
  output$wcOrgan <- renderPlot({
    v <-terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5), min.freq= input$freq, max.words=input$max, colors=brewer.pal(8, "Dark2"))
  })
  
  specTable =function(){
    
  }
map = function (){
  locCount <- count(data$Center)
}
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles( urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -4.2882, lat = 55.8721, zoom = 4)
  })
      

  


}    


)

    
  
