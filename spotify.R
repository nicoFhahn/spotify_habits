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
  limit = 10,
  authorization = code
)

id_1 <- longterm_art[1, ]$id
albums_1 <- get_artist_albums(id_1, include_groups = "album")
albums_1 <- dedupe_album_names(albums_1, album_name_col = "name", album_release_year_col = "release_date")
albums_data_1 <- get_albums(albums_1$id)
audio_features_1 <- get_artist_audio_features(id_1)
album_features_1 <- split(audio_features_1, audio_features_1$album_id)
album_lengths_1 <- lapply(
  album_features_1, function(x) {
    data.frame(
      length = sum(x$duration_ms),
      name = x$album_name
    )[1, ]
  }
)
album_lengths_1 <- Reduce(rbind, album_lengths_1)
newest_album_1 <- audio_features_1[audio_features_1$album_release_date == max(audio_features_1$album_release_date), c("album_name", "album_release_date")][1, ]

related_1 <- get_related_artists(id_1)

# song related data
number_of_songs_1 <- nrow(audio_features_1)
song_ids_1 <- audio_features_1$track_id
n <- length(song_ids_1)
k <- 50 ## your LEN
a <- split(song_ids_1, rep(1:ceiling(n/k), each=k)[1:n])
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
rm(list=setdiff(ls(), c(
  "number_of_songs_1",
  "most_popular_songs_1",
  "least_popular_songs_1",
  "number_of_albums_1",
  "most_popular_albums_1",
  "least_popular_albums_1",
  "newest_album_1",
  "album_lengths_1",
  "genre_1",
  "popularity_1",
  "related_artists_1",
  "image_1"
  )))
hchart(density(audio_features_1$danceability), type = "area", color = "#B71C1C", name = "Price")

audio_features_1 %>%
  e_charts() %>%
  e_density(danceability, areaStyle = list(opacity = .4), smooth = TRUE, name = "density", y_index = 1) %>%
  e_tooltip(trigger = "axis")
# compare to your recent top 20 artists:
get_my_top_artists_or_tracks(type = "artists", time_range = "short_term", limit = 20, authorization = code) %>%
  select(name, genres) %>%
  rowwise() %>%
  mutate(genres = paste(genres, collapse = ", ")) %>%
  ungroup()

# show favorite key of any of these
artist <- get_artist_audio_features("The Gorillaz")
# top 10 keys of artist
artist %>%
  count(key_mode, sort = TRUE) %>%
  head(10)
# Their most joyful songs
# maybe also get the most energetic songs
artist %>%
  arrange(-valence) %>%
  select(track_name, valence) %>%
  head(20)


# joyplot
library(ggjoy)

ggplot(artist, aes(x = valence, y = album_name)) +
  geom_joy() +
  theme_joy() +
  ggtitle("Joyplot of The Gorillaz's joy distributions", subtitle = "Based on valence pulled from Spotify's Web API with spotifyr")


joy %>%
  arrange(-valence) %>%
  select(track_name, valence) %>%
  head(5)


# your all time favorite songs
get_my_top_artists_or_tracks(type = "tracks", time_range = "long_term", limit = 20) %>%
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>%
  select(name, artist.name, album.name)

# recently favs
get_my_top_artists_or_tracks(type = "tracks", time_range = "short_term", limit = 20) %>%
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>%
  select(name, artist.name, album.name)

get_related_artists(artist$artist_id[1])
get_my_currently_playing()
