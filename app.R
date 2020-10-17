library(dotenv)
library(dplyr)
library(highcharter)
library(lubridate)
library(mlr)
library(plyr)
library(rlist)
library(shiny)
library(shinybusy)
library(shinyjs)
library(shinyWidgets)
library(spotifyr)
library(sass)
library(stringr)
local <- FALSE
css <- sass(sass_file("www/styles.scss"))
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value
# Define server logic required to draw a histogram
server <- function(input, output) {
  source(file.path("server", "functions.R"), local = TRUE)$value
  if (local) {
    load("files.RData")
  } else {
    source(file.path("server", "create_spotify_thingys.R"), local = TRUE)$value
  }
  source(file.path("server", "create_html_thingys.R"), local = TRUE)$value
  source(file.path("server", "cluster_react.R"), local = TRUE)$value
  source(file.path("server", "highcharts.R"), local = TRUE)$value
  source(file.path("server", "ui_outputs.R"), local = TRUE)$value
  source(file.path("server", "modal.R"), local = TRUE)$value
  source(file.path("server", "reactive_values.R"), local = TRUE)$value
  source(file.path("server", "text_outputs.R"), local = TRUE)$value
}

# Run the application
shinyApp(
  ui = ui,
  server = server
)
