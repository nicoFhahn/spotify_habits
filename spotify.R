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

id_1 <- longterm_art[1, ]$id
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
features <- audio_features_1[, c(
  "acousticness", "danceability", "energy",
  "instrumentalness", "loudness", "speechiness",
  "valence", "tempo", "duration_ms", "album_name"
)]

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
  "image_1",
  "longterm_art",
  "urls"
)))

hchart(density(audio_features_1$danceability), type = "area", color = "#B71C1C", name = "Price")


a <- hist(features$acousticness, plot = FALSE)
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
  hc_yAxis(
    title = list(text = "Count"),
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
    color = "rgba(0,0,0,0)",
    groupPadding = 0,
    pointPadding = 0
  ) %>%
  hc_chart(backgroundColor = "#121212") %>%
  hc_legend(enabled = FALSE)
