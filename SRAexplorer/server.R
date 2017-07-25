# server.R
library(shiny)
library(maps)
library(mapproj)

source("helpers.R")


shinyServer(
  function(input, output) {
    
    output$map <- renderPlot({
      
      percent_map()
    })
      
  }
    )