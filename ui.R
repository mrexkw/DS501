library(shiny)

pageWithSidebar(
  headerPanel('Analyzing Top Music Hits w/ K-Means'),
  
  #inputs
  sidebarPanel(
    selectInput(
      inputId = "ycol",
      label = "Y Variable:",
      choices = c("year", "bpm", "nrgy", "dnce", "dB", "live", "val", "dur", "acous", "spch", "pop" ),
      selected = "nrgy"
    ),
    
    selectInput(
      inputId = "xcol",
      label = "X Variable:",
      choices = c("year", "bpm", "nrgy", "dnce", "dB", "live", "val", "dur", "acous", "spch", "pop"),
      selected = "bpm"
    ),
    
    numericInput('clusters', 'Cluster count', 3, min = 1, max = 8)
  ),
  
  # Output:
  mainPanel(
    tabsetPanel(
      tabPanel("Clustering by 2 variables", plotOutput("plot1")),
      tabPanel("Clusterings Summary",  dataTableOutput("genStat")),
      tabPanel("Genre Distribution", plotOutput("genreDist"))
    )
  )
)