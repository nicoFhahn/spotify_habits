library(dotenv)
library(shiny)
library(shinyjs)
library(spotifyr)
library(sass)
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
print(Sys.getenv("SPOTIFY_CLIENT_ID"))
css <- sass(sass_file("www/style.scss"))
access_token <- get_spotify_access_token()
code <- get_spotify_authorization_code()
longterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "long_term",
  limit = 10,
  authorization = code
)
# Define UI for application that draws a histogram
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value

# Define server logic required to draw a histogram
server <- function(input, output) {
    # shinyjs::onclick(
    #     "alltime_1",
    #     showModal(
    #         modalDialog(
    #             easyClose = TRUE,
    #             title = "Test"
    #         )
    #     )
    #     )
    source(file.path("server", "alltime_artists.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
