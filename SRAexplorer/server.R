#-----------SERVER SCRIPT---------#

#load require libraries
library(shiny)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(base)
library(leaflet)


# load you dataset
dataset <- read.csv("completedata.txt", header= TRUE, sep=",")
geocode <- read.table("geoMerge.txt", header=TRUE, sep="\t")
geocode <- na.omit(geocode)


geocode <-geocode[order(-geocode$freq),]
Top20 <- geocode[1:21,]
Top30 <-geocode[1:30,]
Top30 <- Top30[c(1,4)]
colnames(Top30)[which(names(Top30) == "V1")] <- "Institute"

## Define server logic required to generate and plot a random distribution
shinyServer(function(input,output) {
  
  reactMap <- reactive({
    freqS<- input$freqslide
      geocode[geocode$freq >=freqS[1] & geocode$freq <= freqS[2],]
  })
  colorpal <- reactive({
    colorNumeric(input$colours, geocode$freq)
  })
 #filtering for Organism Specific Tab
  reactfilter <- reactive({
    # create a variable from the user input
    organismSelected<-input$x
    # filter your dataset
    filtered<-dataset[dataset$Common.Name==organismSelected,]
    platformSelected<-input$y
    if(input$y != 'All'){
      filtered<-filtered[filtered$Model==platformSelected,]
    }
    filtered
    })
  
  #filtering for Timeline Tab
  reactTimeline <- reactive({
    dateSelected<-input$rb
      filterRB <-dataset[dataset$Date==dateSelected,]
     
  })
  
  modelGraph = function(){
    # fetch the filtered dataset
    filterRB<-reactTimeline()
    
    # create the ggplot
    p <- ggplot(filterRB,aes(x=Model, y=Bases))+geom_bar(aes(fill=Model),stat="identity", width=0.4)+coord_flip()+theme_minimal()
    
  }
  # this is the function for plotting the comapny versus bases which has been filtered for a particular organism
  company = function(){
    # fetch the filtered dataset
    filtered<-reactfilter()
    
    # create the ggplot
    p <- ggplot(filtered,aes(x=Model, y=Bases))+geom_bar(aes(fill=Model),stat="identity", width=0.5)+theme_minimal()
    p <- p + labs(x = "Model")
    p <- p + labs(y = "Bases (log10)")
    p
    
  }
  libSource = function(){
    #fetch the filtered dataset
    filtered <- reactfilter()
    
    #create plot
    p<-ggplot(subset(filtered, !is.na(LibrarySource)), aes(x=LibrarySource))+geom_bar(aes(fill=LibrarySource),stat="count", width=0.5)+theme_minimal()
    p <- p + labs(x = "Library Source of Sequence")
    p <- p + labs(y = input$x )
    p
  }
  orgYear = function(){
    #fetch the filtered dataset
    filtered<- reactfilter()
    
    p<-ggplot(filtered, aes(x=Date))+geom_bar(aes(fill=LibraryStrategy), width=0.5)+theme_minimal()
    p <- p + labs(x = "Year")
    p <- p + labs(y = input$x )
    p
  }
  
  
  #This function is for line graph of Platforms over the years, poor code *needs improved*
  bases = function(){
    dLine <- dataset[c(-1,-2,-3,-4,-5,-6,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30)]
    
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
  
  #outputing all the graphs to be transfer to UI.R for display
  output$modelGraph <-renderPlot({
    print(modelGraph())
  })
  output$base<- renderPlot({
    print(bases())
  }) 
  
  output$companyPlot <- renderPlot({
    # call the function for creating the ggplot
    print(company())
  })
  output$libSourcePlot <- renderPlot({
    # the line below is just for checking that there is a variable called Campany before printing
    if (is.null(reactfilter()$LibrarySource)) return(NULL)
    # call the function for creating the ggplot
    print(libSource())
  })
  output$orgYearPlot <- renderPlot({
    print(orgYear())
    
  })
  # Create word cloud output
  output$cloud = renderPlot({
    docs <- Corpus(VectorSource(dataset$Common.Name)) 
    inspect(docs)
    #text transformation
    toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
    docs <- tm_map(docs, toSpace, "/")
    docs <- tm_map(docs, toSpace, "@")
    docs <- tm_map(docs, toSpace, "\\|")
    #cleaning the text
    docs <- tm_map(docs, removeWords, stopwords("english"))
    docs <- tm_map(docs, removeWords, c("human"))
    dtm <- TermDocumentMatrix(docs)
    #Building a term-document matrix
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    d <- data.frame(word = names(v),freq=v)
    head(d, 10)
    #Generate a word cloud
    set.seed(1234)
    wordcloud(words = d$word, freq = d$freq, min.freq = 1,scale=c(5,1.5),
              max.words=75, random.order=FALSE, rot.per=0.35, 
              colors=brewer.pal(8, "Dark2"))
  })
 
  
  output$mymap <- renderLeaflet({
    leaflet(geocode) %>%
      addTiles( urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))
  })
  
  # the lines below are just for checking whether the table is being filtered
  output$text1 <- renderText({
    filterMap<-reactMap()
    paste("You have selected", input$freqslide, "dataframe dimension", dim(filterMap)[1])
          #"and platform" , input$y, "dataframe dimension", dim(filtered)[1] , " by ", dim(filtered)[2], " column names", unique(as.character(filtered$company)))

  })
  
  output$orgGraph <- renderPlot({
    filterOG <- reactTimeline()
    Top10 <-count(filterOG$Common.Name)
    print(Top10)
    # Top10 <- Top10[order(-Top10$freq),]
    # Top10 <- Top10[1:11,]
    # Top10 <- na.omit(Top10)
    
    print(Top10)
    
   # p <- ggplot(Top10, aes(x=Common.Name, y=freq))+geom_bar(aes(fill=Common.Name),stat="identity")+theme_minimal()
   #  
   # p
    
    
  })
  observe({
    pal <- colorpal()
    
    leafletProxy("mymap", data = reactMap()) %>%
      clearShapes() %>%
      addCircleMarkers(radius = 5, weight = 1, color = "#777777",
                 fillColor = ~pal(freq), fillOpacity =0.7, popup=~paste(V1,":", freq),
                 clusterOptions = markerClusterOptions())
      
  })
  observe({
    proxy <- leafletProxy("mymap", data = geocode)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
      pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                          pal = pal, values = ~freq
      )
    }
    output$mapTable <- renderTable(Top30)
    
    
  })
  
  
  
}) 

    
  
