# server.R
#installing appropriate libraries
library(shiny)
library(maps)
library(mapproj)
library(ggplot2)
library(gridExtra)
library(ape)
library(wordcloud)
library(RColorBrewer)
library(plyr)

#gathering all information requred
data <- read.csv("ShinyData.txt", header=TRUE, sep="\t", na.strings=c("NA", "", "n/a"))
#can correlate all data here.
data$Model <- as.factor((data$Model))
platforms <- levels(data$Model)
countPlatform = count(data, data$Model)
countPlatform <- countPlatform[order(-countPlatform$n),]

#No. rows from platCounts df, necessary for barplot
rowsX <- nrow(countPlatform)

#Build dataframe for barplot
Freq = countPlatform[2]
dose=countPlatform[1]
df <- data.frame(dose=countPlatform[1],
                 Freq=countPlatform[2])
# df$Model <- droplevels(df$Model)

Model<- reorder(df$data.Model, -df$n)



shinyServer(
  #function's for plot(s) on overview page.
function(input, output) {
  plat = function(){
  
  
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
      
}    
    
  #functiond for interactive map
 # map = function(){}
)

    
  
