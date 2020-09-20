library(spotifyr)
library(dotenv)
library(lubridate)
library(dplyr)
library(knitr)
library(tidyverse)
library(highcharter)
load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
code <- get_spotify_authorization_code()
# first get your all time top 20 artists:
longterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "long_term",
  limit = 15,
  authorization = code
)

id_1 <- longterm_art[15, ]$id
albums_1 <- get_artist_albums(id_1, include_groups = "album")
albums_1 <- dedupe_album_names(albums_1, album_name_col = "name", album_release_year_col = "release_date")
albums_data_1 <- get_albums(albums_1$id)
audio_features_1 <- get_artist_audio_features(id_1)
album_features_1 <- split(audio_features_1, audio_features_1$album_id)
album_features_1 <- lapply(
  album_features_1, function(x) {
    data.frame(
      length = sum(x$duration_ms),
      acousticness = mean(x$acousticness),
      danceability = mean(x$danceability),
      energy = mean(x$energy),
      instrumentalness = mean(x$instrumentalness),
      loudness = mean(x$loudness),
      speechiness = mean(x$speechiness),
      valence = mean(x$valence),
      tempo = mean(x$tempo),
      release_date = unique(x$album_release_date),
      name = x$album_name
    )[1, ]
  }
)
album_features_1 <- Reduce(rbind, album_features_1)
missing_date <- album_features_1[!str_detect(album_features_1$release_date, "[0-9]{4}-"), ]
album_features_1[!str_detect(album_features_1$release_date, "[0-9]{4}-"), ] <- NA
album_features_1 <- album_features_1[complete.cases(album_features_1), ]
for (i in 1:nrow(missing_date)) {
  if (missing_date[i, ]$name %in% album_features_1$name) {
    missing_date[i, ]$release_date <- album_features_1[album_features_1$name == missing_date$name[i], ]$release_date
  } else {
    missing_date[i, ]$release_date <- paste(missing_date[i, ]$release_date, "-06-30", sep = "")
  }
}

album_features_1 <- rbind(album_features_1, missing_date)
album_features_1$release_date <- as.Date(album_features_1$release_date)

related_1 <- get_related_artists(id_1)

# song related data
number_of_songs_1 <- nrow(audio_features_1)
song_ids_1 <- audio_features_1$track_id
n <- length(song_ids_1)
k <- 50 ## your LEN
a <- split(song_ids_1, rep(1:ceiling(n / k), each = k)[1:n])
features <- lapply(a, function(x) {
  features <- get_tracks(x)[, c("name", "popularity")]
})
songs_popularity_1 <- Reduce(rbind, features)
songs_popularity_1 <- songs_popularity_1[songs_popularity_1$popularity > 0, ]
most_popular_songs_1 <- songs_popularity_1[songs_popularity_1$popularity == max(songs_popularity_1$popularity), ]
least_popular_songs_1 <- songs_popularity_1[songs_popularity_1$popularity == min(songs_popularity_1$popularity), ]

# album related data
number_of_albums_1 <- nrow(albums_data_1)
most_popular_albums_1 <- albums_data_1[albums_data_1$popularity == max(albums_data_1$popularity), c("name", "popularity", "images")]
least_popular_albums_1 <- albums_data_1[albums_data_1$popularity == min(albums_data_1$popularity), c("name", "popularity", "images")]
# artist related data
genre_1 <- longterm_art[1, ]$genres[[1]][1]
popularity_1 <- longterm_art[1, ]$popularity
related_artists_1 <- related_1$name[1:10]
image_1 <- longterm_art[1, ]$images[[1]][1, 2]

urls <- unlist(lapply(longterm_art$images, function(x) x$url[1]))
audio_features_1 <- audio_features_1[
  !str_detect(
    audio_features_1$track_name,
    "(Intro|Interlude)"
  ),
]

audio_features_1$minutes <- as.numeric(str_extract(audio_features_1$duration_ms / 60000, "[0-9]{1,}"))
audio_features_1$seconds <- round(as.numeric(str_extract(audio_features_1$duration_ms / 60000, "\\.[0-9]{1,}")) * 60)
audio_features_1$seconds[!str_detect(audio_features_1$seconds, "[0-9]{2}")] <- paste(
  "0",
  audio_features_1$seconds[!str_detect(audio_features_1$seconds, "[0-9]{2}")],
  sep = ""
)

rm(list = setdiff(ls(), c(
  "number_of_songs_1",
  "most_popular_songs_1",
  "least_popular_songs_1",
  "number_of_albums_1",
  "most_popular_albums_1",
  "least_popular_albums_1",
  "album_features_1",
  "genre_1",
  "popularity_1",
  "related_artists_1",
  "longterm_art",
  "urls",
  "audio_features_1"
)))






a <- hist(audio_features_1$speechiness, plot = FALSE, breaks = seq(0, 1, 0.1))
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
    labels = list(
      style = list(
        color = "#fff"
      )
    )
  ) %>%
  hc_add_series(
    data = a$counts,
    borderColor = "#EA5F23",
    color = "rgba(234, 95, 35, 0.1)",
    groupPadding = 0,
    pointPadding = 0
  ) %>%
  hc_yAxis(
    title = list(
      text = "Count",
      style = list(
        color = "#fff"
      )
    ),
    gridLineWidth = 0,
    labels = list(
      style = list(
        color = "#fff"
      )
    )
  ) %>%
  hc_chart(backgroundColor = "#242424") %>%
  hc_title(
    text = "Acousticness of Gorillaz Songs",
    style = list(color = "#fff")
  ) %>%
  hc_legend(enabled = FALSE)

max <- plyr::round_any(max(audio_features_1$duration_ms / 1000), 100)
a <- hist(audio_features_1$duration_ms / 1000, plot = FALSE, breaks = seq(0, max, 100))
iv <- seq(0, max, 100)
iv <- lapply(2:length(iv), function(x, ...) {
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
    pointPadding = 0,
    tooltip = list(
      pointFormat = paste(
        "Number of songs: {point.y}"
      ),
      headerFormat = "<span style='font-weight:bold'>{point.x}: </span><br>"
    )
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
  hc_legend(enabled = FALSE)


dens <- density(audio_features_1$speechiness, from = 0, to = 1)
dens$y <- dens$y / sum(dens$y)


highchart() %>%
  # area chart
  hc_chart(type = "area") %>%
  # set the theme
  hc_add_theme(hc_theme_monokai()) %>%
  # add the x axis values
  hc_xAxis(
    # set the categories
    categories = round(dens$x, ifelse(any(dens$x) > 1, 1, 2)),
    # no gridLine
    gridLineWidth = 0,
    # set the title
    title = list(
      # style the title
      style = list(
        color = "#fff",
        `font-size` = "calc(0.4em + 0.5vw)"
      )
    ),
    # style the labels
    labels = list(
      style = list(
        color = "#fff",
        `font-size` = "calc(0.3em + 0.5vw)"
      )
    ),
    # set the tick interval
    tickInterval = 20
  ) %>%
  # add the data for the density
  hc_add_series(
    data = dens$y,
    # style it
    color = "rgba(234, 95, 35, 1)",
    fillColor = "rgba(234, 95, 35, 0.1)"
  ) %>%
  # style the y-axis
  hc_yAxis(
    # set the title
    title = list(
      text = "Density",
      # style it
      style = list(
        color = "#fff",
        `font-size` = "calc(0.4em + 0.5vw)"
      )
    ),
    # style the gridLine
    gridLineWidth = 1,
    gridLineColor = "rgba(255, 255, 255, 0.3)",
    gridLineDashStyle = "Solid",
    # style the labels
    labels = list(
      style = list(
        color = "#fff",
        `font-size` = "calc(0.3em + 0.5vw)"
      )
    )
  ) %>%
  # set the background color
  hc_chart(backgroundColor = "#242424") %>%
  # set the title
  hc_title(
    text = paste(
      "of",
      "songs"
    ),
    # style it
    style = list(
      color = "#fff",
      `font-size` = "calc(1em + 0.5vw)"
    )
  ) %>%
  # remove the legend
  hc_legend(enabled = FALSE) %>%
  # remove the tooltip
  hc_tooltip(enabled = FALSE)
