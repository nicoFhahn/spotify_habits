library(dotenv)
library(highcharter)
library(plyr)
library(shiny)
library(shinybusy)
library(shinyjs)
library(shinyWidgets)
library(spotifyr)
library(sass)
library(stringr)
source(file.path("server", "create_spotify_thingys.R"), local = TRUE)$value
css <- sass(sass_file("www/styles.scss"))
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value
# Define server logic required to draw a histogram
server <- function(input, output) {
  # runjs(jsCode)
  source(file.path("server", "highcharts.R"), local = TRUE)$value
  source(file.path("server", "artist_modal.R"), local = TRUE)$value
  source(file.path("server", "reactive_values.R"), local = TRUE)$value
  source(file.path("server", "functions.R"), local = TRUE)$value
  source(file.path("server", "text_outputs.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
