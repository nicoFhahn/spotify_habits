library(dotenv)
library(fullPage)
library(shiny)
library(shinyjs)
library(spotifyr)
library(sass)
library(scrollrevealR)
library(stringr)
longdiv <- function(...) {
  div(
    ...,
    class = "container",
    style = "height:100vh;"
  )
}
bigbreak <- function(n) {
  HTML(paste(rep("<br></br>", n), collapse = ""))
}
load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
# code <- get_spotify_authorization_code()
load("artist.RData")
css <- sass(sass_file("www/styles.scss"))
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value

# Define server logic required to draw a histogram
server <- function(input, output) {
  modal_rv <- reactiveValues(click = 0)
  shinyjs::onclick(
    "artist_at_1",
    print("moin")
  )
  # runjs(jsCode)
  source(file.path("server", "highcharts.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
