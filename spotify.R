library(spotifyr)
library(dotenv)
library(future)
library(lubridate)
library(dplyr)
library(knitr)
library(tidyverse)
library(highcharter)
load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
code <- get_spotify_authorization_code()
# first get your all time top 20 artists:
short_term <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "short_term",
  limit = 30,
  authorization = code
)
albums <- get_artist_albums(short_term$id[11], include_groups = "album")
audio_features <- get_artist_audio_features(
  short_term$id[25],
  include_groups = c("single", "album")
  )
audio_features <- list()
start <- Sys.time()
audio_features <- lapply(
  short_term$id,
  function(x, ...) {
    features <- get_artist_audio_features(
      x,
      include_groups = c("single", "album")
      )
    Sys.sleep(3)
    features %>%
      group_by(artist_name) %>%
      summarise(
        danceability = mean(danceability),
        energy = mean(energy),
        loudness = mean(loudness),
        speechiness = mean(speechiness),
        acousticness = mean(acousticness),
        instrumentalness = mean(instrumentalness),
        liveness = mean(liveness),
        valence = mean(valence),
        tempo = mean(tempo),
        explicit = mean(explicit)
      )
  }
)
audio_features_df <- Reduce(rbind, audio_features)
library(mlr)
task <- makeClusterTask(
  id = "cluster",
  data = audio_features_df[, c(
    "acousticness", "danceability", "instrumentalness", "energy", "speechiness"
    )]
)
learner_names <- c(
  "cluster.cmeans",
  "cluster.kkmeans",
  "cluster.kmeans"
)
learners <- lapply(learner_names, makeLearner, centers = 6)
models_trained <- lapply(learners, train, task)
models <- lapply(models_trained, getLearnerModel)
audio_features_df$cluster <- models[[1]]$cluster
audio_features_df[audio_features_df$cluster == 6, ]
