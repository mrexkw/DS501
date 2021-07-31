# Load packages
library(readr)
library(shiny)
library(ggplot2)
library(tidyverse)

# Load & Clean data
top50dataset <- read_csv("top50dataset.csv")
# function to fix data types (characters to numeric)
to_numeric_and_round_func <- function(x){
  round(as.numeric(as.character(x)),2)
}
# Mutate character types to numeric
cleanData <- top50dataset%>%
  mutate_at(vars(-one_of("title", "artist", "top genre")), to_numeric_and_round_func)
#remove extra column
top50dates...1 <- NULL



# Define server
server <- function(input, output, session) {
  
  #Cluster by 2 variables
  selectedData <- reactive({
    cleanData[, c(input$xcol, input$ycol)]
  })
  
  dataClusters <- reactive({ 
    kmeans(selectedData(), centers = input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#A44A3F", "#C7AC92", "#94A89A", "#9CB380" , "#ECDD7B", "#28262C", "#685369", "#16450C"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = dataClusters()$cluster,
         pch = 20, cex = 3)
    points(dataClusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  #general stats
  output$genStat <- renderDataTable({
    data.frame(dataClusters()$size, dataClusters()$centers)
  })
  
  
  #genre Distribution
  kmeans_df <- reactive({
    data.frame(Cluster = dataClusters()$cluster, cleanData)
  })
  
  output$genreDist <- renderPlot({
    ggplot(data = kmeans_df(), aes(y = Cluster)) +
      geom_bar(aes(fill = top.genre)) +
      ggtitle("Genre Distribution") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
}