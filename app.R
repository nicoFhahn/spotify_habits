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
        title = HTML(
          paste(
            tags$figure(
              tags$image(
                src = longterm_art$images[[1]]$url[1]
              ),
              tags$figcaption(
                h4(
                  longterm_art$name[1]
                )
              )
            )
          )
        ),
        easyClose = TRUE,
        footer = NULL,
        tabsetPanel(
          tabPanel(
            title = "General information",
            column(
              width = 10,
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
                "#songs on Spotify"
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
            )
          ),
          tabPanel(
            "Album Breakdown 1",
            column(
              width = 10,
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
                    order(album_features_1$length),
                  ][
                    nrow(album_features_1),
                  ][, 11],
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$length),
                    ][
                      nrow(album_features_1),
                    ][, 1] / 60000
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
                    order(album_features_1$length),
                  ][
                    1,
                  ][, 11],
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$length),
                    ][
                      1,
                    ][, 1] / 60000
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
                    order(album_features_1$release_date),
                  ][
                    nrow(album_features_1),
                  ]$name,
                  " (",
                  album_features_1[
                    order(album_features_1$release_date),
                  ][
                    nrow(album_features_1),
                  ]$release_date,
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
                    order(album_features_1$release_date),
                  ][1, ]$name,
                  " (",
                  album_features_1[
                    order(album_features_1$release_date),
                  ][1, ]$release_date,
                  ")",
                  sep = ""
                )
              )
            ),
            column(
              width = 2,
              # tags$figure(
              #   tags$image(
              #     class = "album_cover",
              #     src = most_popular_albums_1$images[[1]][1, 2]
              #   ),
              #   tags$figcaption(
              #     class = "album_caption",
              #     p(
              #       most_popular_albums_1$name 
              #     )
              #   )
              # ),
              div(
                class = "album_container",
                h3(
                  class = "album_title"
                ),
                div(
                  class = "album_content",
                  div(
                    class = "album_content-overlay"
                  ),
                  img(
                    class = "album_content-image",
                    src = most_popular_albums_1$images[[1]][1, 2]
                  ),
                  div(
                    class = "album_content-details fadeIn-bottom",
                    h3(
                      class = "album_content-title",
                      most_popular_albums_1$name
                    ),
                    p(
                      class = "album_content-text",
                      most_popular_albums_1$popularity
                    )
                  )
                )
              ),
              tags$figure(
                tags$image(
                  class = "album_cover",
                  src = least_popular_albums_1$images[[1]][1, 2]
                ),
                tags$figcaption(
                  class = "album_caption",
                  p(
                    least_popular_albums_1$name
                  )
                )
              )
            )
          ),
          tabPanel(
            "Album Breakdown 2",
            column(
              width = 10,
              h6(
                "Most acoustic album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$acousticness, decreasing = TRUE),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$acousticness, decreasing = TRUE),
                    ][1, ]$acousticness,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Most instrumental album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$instrumentalness, decreasing = TRUE),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$instrumentalness, decreasing = TRUE),
                    ][1, ]$instrumentalness,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Most energetic album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$energy, decreasing = TRUE),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$energy, decreasing = TRUE),
                    ][1, ]$energy,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Least energetic album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$energy),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$energy),
                    ][1, ]$energy,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Most danceable album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$danceability, decreasing = TRUE),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$danceability, decreasing = TRUE),
                    ][1, ]$danceability,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Least danceable album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$danceability),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$danceability),
                    ][1, ]$danceability,
                    3
                  ),
                  sep = " - "
                )
              )
            ),
            column(
              width = 2
            )
          ),
          tabPanel(
            "Album Breakdown 3",
            column(
              width = 10,
              h6(
                "Loudest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$loudness, decreasing = TRUE),
                  ][1, ]$name,
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$loudness, decreasing = TRUE),
                    ][1, ]$loudness,
                    3
                  ),
                  " db",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Quietest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$loudness),
                  ][1, ]$name,
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$loudness),
                    ][1, ]$loudness,
                    3
                  ),
                  " db",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Fastest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$tempo, decreasing = TRUE),
                  ][1, ]$name,
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$tempo, decreasing = TRUE),
                    ][1, ]$tempo
                  ),
                  " bpm",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Slowest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$tempo),
                  ][1, ]$name,
                  " - ",
                  round(
                    album_features_1[
                      order(album_features_1$tempo),
                    ][1, ]$tempo
                  ),
                  " bpm",
                  sep = ""
                )
              ),
              br(),
              h6(
                "Happiest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$valence, decreasing = TRUE),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$valence, decreasing = TRUE),
                    ][1, ]$valence,
                    3
                  ),
                  sep = " - "
                )
              ),
              br(),
              h6(
                "Saddest album"
              ),
              p(
                paste(
                  album_features_1[
                    order(album_features_1$valence),
                  ][1, ]$name,
                  round(
                    album_features_1[
                      order(album_features_1$valence),
                    ][1, ]$valence,
                    3
                  ),
                  sep = " - "
                )
              )
            ),
            column(
              width = 2
            )
          ),
          tabPanel(
            "Song Breakdown 1",
            h6(
              ifelse(
                nrow(most_popular_songs_1) > 1,
                "Most popular songs",
                "Most popular song"
              )
            ),
            p(
              ifelse(
                nrow(most_popular_songs_1) > 1,
                paste(
                  paste(
                    most_popular_songs_1$name,
                    collapse = ", "
                  ),
                  most_popular_songs_1$popularity,
                  sep = " - "
                ),
                paste(
                  most_popular_songs_1$name,
                  most_popular_songs_1$popularity,
                  sep = " - "
                )
              )
            ),
            br(),
            h6(
              ifelse(
                nrow(least_popular_songs_1) > 1,
                "Least popular songs",
                "Least popular song"
              )
            ),
            p(
              ifelse(
                nrow(least_popular_songs_1) > 1,
                paste(
                  paste(
                    least_popular_songs_1$name,
                    collapse = ", "
                  ),
                  least_popular_songs_1$popularity,
                  sep = " - "
                ),
                paste(
                  least_popular_songs_1$name,
                  least_popular_songs_1$popularity,
                  sep = " - "
                )
              )
            ),
            br(),
            h6(
              "Longest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$duration_ms, decreasing = TRUE),
                ][
                  1,
                ]$track_name,
                " - ",
                paste(
                  audio_features_1[
                    order(audio_features_1$duration_ms, decreasing = TRUE),
                    ][1, 40:41],
                  collapse = ":"),
                " minutes",
                sep = ""
              )
            ),
            br(),
            h6(
              "Shortest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$duration_ms),
                ][
                  1,
                ]$track_name,
                " - ",
                paste(
                  audio_features_1[
                    order(audio_features_1$duration_ms),
                  ][1, 40:41],
                  collapse = ":"),
                " minutes",
                sep = ""
              )
            )
          ),
          tabPanel(
            "Song Breakdown 2",
            h6(
              "Most acoustic song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$acousticness, decreasing = TRUE),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$acousticness, decreasing = TRUE),
                  ][1, ]$acousticness,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most instrumental song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$instrumentalness, decreasing = TRUE),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$instrumentalness, decreasing = TRUE),
                  ][1, ]$instrumentalness,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most energetic song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$energy, decreasing = TRUE),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$energy, decreasing = TRUE),
                  ][1, ]$energy,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Least energetic song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$energy),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$energy),
                  ][1, ]$energy,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most danceable song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$danceability, decreasing = TRUE),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$danceability, decreasing = TRUE),
                  ][1, ]$danceability,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Least danceable song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$danceability),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$danceability),
                  ][1, ]$danceability,
                  3
                ),
                sep = " - "
              )
            )
          ),
          tabPanel(
            "Song Breakdown 3",
            h6(
              "Loudest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$loudness, decreasing = TRUE),
                ][1, ]$track_name,
                " - ",
                round(
                  audio_features_1[
                    order(audio_features_1$loudness, decreasing = TRUE),
                  ][1, ]$loudness,
                  3
                ),
                " db",
                sep = ""
              )
            ),
            br(),
            h6(
              "Quietest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$loudness),
                ][1, ]$track_name,
                " - ",
                round(
                  audio_features_1[
                    order(audio_features_1$loudness),
                  ][1, ]$loudness,
                  3
                ),
                " db",
                sep = ""
              )
            ),
            br(),
            h6(
              "Fastest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$tempo, decreasing = TRUE),
                ][1, ]$track_name,
                " - ",
                round(
                  audio_features_1[
                    order(audio_features_1$tempo, decreasing = TRUE),
                  ][1, ]$tempo
                ),
                " bpm",
                sep = ""
              )
            ),
            br(),
            h6(
              "Slowest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$tempo),
                ][1, ]$track_name,
                " - ",
                round(
                  audio_features_1[
                    order(audio_features_1$tempo),
                  ][1, ]$tempo
                ),
                " bpm",
                sep = ""
              )
            ),
            br(),
            h6(
              "Happiest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$valence, decreasing = TRUE),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$valence, decreasing = TRUE),
                  ][1, ]$valence,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Saddest song"
            ),
            p(
              paste(
                audio_features_1[
                  order(audio_features_1$valence),
                ][1, ]$track_name,
                round(
                  audio_features_1[
                    order(audio_features_1$valence),
                  ][1, ]$valence,
                  3
                ),
                sep = " - "
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
