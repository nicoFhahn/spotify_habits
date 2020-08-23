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
access_token <- get_spotify_access_token()
# code <- get_spotify_authorization_code()
load("artist.RData")
css <- sass(sass_file("www/styles.scss"))
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value

# Define server logic required to draw a histogram
server <- function(input, output) {
  modal_rv <- reactiveValues(click = 0)
  shinyjs::onclick(
    "click",
    showModal(
      modalDialog(
        class = "artist_modal",
        title = longterm_art$name[1],
        easyClose = TRUE,
        footer = NULL,
        tabsetPanel(
          tabPanel(
            title = "General information",
            h6(
              "Genre"
            ),
            p(
              genre_1
            ),
            br(),
            h6(
              "Populartiy"
            ),
            p(
              popularity_1
            ),
            br(),
            h6(
              "#Followers"
            ),
            p(
              format(longterm_art$followers.total[1], big.interval = 3, big.mark = " ")
            ),
            br(),
            h6(
              "#Albums on Spotify"
            ),
            p(
              number_of_albums_1
            ),
            br(),
            h6(
              "#Songs on Spotify"
            ),
            p(
              number_of_songs_1
            ),
            br(),
            h6(
              "Related artists"
            ),
            p(
              paste(related_artists_1[1:5], collapse = ", ")
            )
          ),
          tabPanel(
            "Album Breakdown 1",
            column(
              width = 6,
              h6(
                ifelse(
                  nrow(most_popular_albums_1) > 1,
                  "Most popular albums",
                  "Most popular album"
                  )
              ),
              p(
                ifelse(
                  nrow(most_popular_albums_1) > 1,
                  paste(
                    paste(
                      most_popular_albums_1$name,
                      collapse = ", "
                    ),
                    most_popular_albums_1$popularity,
                    sep = " - "
                  ),
                  paste(
                    most_popular_albums_1$name,
                    most_popular_albums_1$popularity,
                    sep = " - "
                  )
                )
              ),
              br(),
              h6(
                ifelse(
                  nrow(least_popular_albums_1) > 1,
                  "Least popular albums",
                  "Least popular album"
                )
              ),
              p(
                ifelse(
                  nrow(least_popular_albums_1) > 1,
                  paste(
                    paste(
                      least_popular_albums_1$name,
                      collapse = ", "
                    ),
                    least_popular_albums_1$popularity,
                    sep = " - "
                  ),
                  paste(
                    least_popular_albums_1$name,
                    least_popular_albums_1$popularity,
                    sep = " - "
                  )
                )
              ),
              br(),
              h6(
                "Longest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$length), ][
                      nrow(album_features_1), ][, 11],
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$length), ][
                        nrow(album_features_1), ][, 1] / 60000
                    ),
                  " minutes",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Shortest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$length), ][
                      1, ][, 11],
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$length), ][
                        2, ][, 1] / 60000
                  ),
                  " minutes",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Newest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$release_date), ][
                      nrow(album_features_1), ]$name,
                  " (",
                  album_features_1[
                    order(album_features_1$release_date), ][
                      nrow(album_features_1), ]$release_date,
                  ")",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Oldest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$release_date), ][1, ]$name,
                  " (",
                  album_features_1[
                    order(album_features_1$release_date), ][1, ]$release_date,
                  ")",
                  sep = ""
                )
              )
            ),
            column(
              width = 6,
              h6(
                "Test"
              )
            )
          )
        )
      )
    )
  )
  # runjs(jsCode)
  source(file.path("server", "highcharts.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
