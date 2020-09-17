library(dotenv)
library(shiny)
library(shinyjs)
library(shinyWidgets)
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
              img(
                class = "album_cover",
                src = most_popular_albums_1$images[[1]][1, 2]
              ),
              img(
                class = "album_cover",
                src = least_popular_albums_1$images[[1]][1, 2]
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
          ),
          tabPanel(
            "Song Breakdown 4",
            br(),
            fluidRow(
              column(
                width = 4,
                pickerInput(
                  "plot_var",
                  choices = c(
                    "Acousticness",
                    "Danceability",
                    "Energy",
                    "Instrumentalness",
                    "Liveness",
                    "Loudness",
                    "Speechiness",
                    "Tempo",
                    "Valence"
                  ),
                  selected = "Acousticness",
                  options = list(
                    style = c("background: #242424;"),
                    header = "Audio feature to display"
                  )
                )
              ),
              column(
                width = 4,
                pickerInput(
                  "plot_type",
                  choices = c(
                    "Density",
                    "Histogram"
                  ),
                  selected = "Density",
                  options = list(
                    style = c("background: #242424;"),
                    header = "Type of Plot"
                  )
                )
              )
            ),
            fluidRow(
              column(
                width = 8,
                highchartOutput(
                  "art1_plot",
                  height = "60vh"
                )
              )
            )
          )
        )
      )
    )
  )
  
  output$art1_plot <- renderHighchart({
    if(input$plot_type == "Density") {
      a   = density(audio_features_1[, tolower(input$plot_var)])
      a$y = a$y/sum(a$y)
      highchart() %>%
        hc_chart(type = "area") %>%
        hc_add_theme(hc_theme_monokai()) %>%
        hc_xAxis(
          categories = round(a$x, ifelse(any(a$x) > 1, 1, 2)),
          gridLineWidth = 0,
          title = list(
            text = input$plot_var,
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          ),
          tickInterval = 20
        ) %>%
        hc_add_series(
          data = a$y,
          color = "rgba(234, 95, 35, 1)",
          fillColor = "rgba(234, 95, 35, 0.1)"
        ) %>%
        hc_yAxis(
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_chart(backgroundColor = "#242424") %>%
        hc_title(
          text = paste(
            input$plot_var,
            "of",
            longterm_art$name[1],
            "songs"
          ),
          style = list(
            color = "#fff",
            `font-size` = "calc(1em + 0.5vw)"
          )
        ) %>%
        hc_legend(enabled = FALSE)
    } else {
      if(input$plot_var %in% c(
        "Acousticness", "Danceability", "Energy",
        "Instrumentalness", "Liveness", "Speechiness",
        "Valence"
      )) {
        a <- hist(audio_features_1[, tolower(input$plot_var)], plot = FALSE, breaks = seq(0, 1, 0.1))
        iv <- lapply(2:11, function(x, ...) {
          paste("(", a$breaks[x - 1], ", ", a$breaks[x], "]", sep = "")
        })
        
        highchart() %>%
          hc_chart(type = "column") %>%
          hc_add_theme(hc_theme_monokai()) %>%
          hc_xAxis(
            categories = iv,
            min = -0.01,
            gridLineWidth = 0,
            title = list(
              text = input$plot_var,
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            )
          ) %>%
          hc_add_series(
            data = a$counts,
            borderColor = "#EA5F23",
            color = "rgba(234, 95, 35, 0.2)",
            groupPadding = 0,
            pointPadding = 0
          ) %>%
          hc_yAxis(
            title = list(
              text = "Count",
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            gridLineWidth = 1,
            gridLineColor = "rgba(255, 255, 255, 0.3)",
            gridLineDashStyle = "Solid",
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            )
          ) %>%
          hc_chart(backgroundColor = "#242424") %>%
          hc_title(
            text = paste(
              input$plot_var,
              "of",
              longterm_art$name[1],
              "songs"
            ),
            style = list(
              color = "#fff",
              `font-size` = "calc(1em + 0.5vw)"
            )
          ) %>%
          hc_legend(enabled = FALSE)
      } else if(input$plot_var == "Loudness") {
        a <- hist(audio_features_1$loudness, plot = FALSE, breaks = seq(-60, 0, 2))
        iv <- seq(-60, 0, 10)
        iv2 <- unlist(lapply(iv, function(x) {
          c(x, rep("", 4))
        }))
        highchart() %>%
          hc_chart(type = "column") %>%
          hc_add_theme(hc_theme_monokai()) %>%
          hc_xAxis(
            categories = iv2[1:31],
            min = -0.01,
            gridLineWidth = 0,
            title = list(
              text = input$plot_var,
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            ),
            tickInterval = 5
          ) %>%
          hc_add_series(
            data = c(a$counts, 0),
            borderColor = "#EA5F23",
            color = "rgba(234, 95, 35, 0.2)",
            groupPadding = 0,
            pointPadding = 0
          ) %>%
          hc_yAxis(
            title = list(
              text = "Count",
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            gridLineWidth = 1,
            gridLineColor = "rgba(255, 255, 255, 0.3)",
            gridLineDashStyle = "Solid",
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            )
          ) %>%
          hc_chart(backgroundColor = "#242424") %>%
          hc_title(
            text = paste(
              input$plot_var,
              "of",
              longterm_art$name[1],
              "songs"
            ),
            style = list(
              color = "#fff",
              `font-size` = "calc(1em + 0.5vw)"
            )
          ) %>%
          hc_legend(enabled = FALSE)
      } else {
        a <- hist(audio_features_1$tempo, plot = FALSE, breaks = seq(0, 250, 10))
        highchart() %>%
          hc_chart(type = "column") %>%
          hc_add_theme(hc_theme_monokai()) %>%
          hc_xAxis(
            categories = a$breaks,
            min = -0.01,
            gridLineWidth = 0,
            title = list(
              text = input$plot_var,
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            ),
            tickInterval = 5
          ) %>%
          hc_add_series(
            data = a$counts,
            borderColor = "#EA5F23",
            color = "rgba(234, 95, 35, 0.2)",
            groupPadding = 0,
            pointPadding = 0
          ) %>%
          hc_yAxis(
            title = list(
              text = "Count",
              style = list(
                color = "#fff",
                `font-size` = "calc(0.4em + 0.5vw)"
              )
            ),
            gridLineWidth = 1,
            gridLineColor = "rgba(255, 255, 255, 0.3)",
            gridLineDashStyle = "Solid",
            labels = list(
              style = list(
                color = "#fff",
                `font-size` = "calc(0.3em + 0.5vw)"
              )
            )
          ) %>%
          hc_chart(backgroundColor = "#242424") %>%
          hc_title(
            text = paste(
              input$plot_var,
              "of",
              longterm_art$name[1],
              "songs"
            ),
            style = list(
              color = "#fff",
              `font-size` = "calc(1em + 0.5vw)"
            )
          ) %>%
          hc_legend(enabled = FALSE)
      }
    }
  })
  # runjs(jsCode)
  source(file.path("server", "highcharts.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
