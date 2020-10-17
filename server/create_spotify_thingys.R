load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
code <- get_spotify_authorization_code()
# first get your all time top artists:
longterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "long_term",
  limit = 50,
  authorization = code
)
shortterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "short_term",
  limit = 50,
  authorization = code
)
longterm_tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  time_range = "long_term",
  limit = 50,
  authorization = code
)
shortterm_tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  time_range = "short_term",
  limit = 50,
  authorization = code
)
urls_alltime <- unlist(lapply(longterm_art$images, function(x) x$url[1]))[1:20]
urls_recent <- unlist(lapply(shortterm_art$images, function(x) x$url[1]))[1:20]
urls_alltime_songs <- unlist(
  lapply(longterm_tracks$album.images, function(x) x$url[1])
)[1:20]
urls_recent_songs <- unlist(
  lapply(shortterm_tracks$album.images, function(x) x$url[1])
)[1:20]

all_tracks <- get_all_saved_stuff()
all_tracks$year <- year(all_tracks$added_at)
all_tracks$month <- month(all_tracks$added_at)
all_tracks_grouped <- all_tracks %>%
  group_by(
    year, month
  ) %>%
  dplyr::summarise(
    acousticness = mean(acousticness, na.rm = TRUE),
    danceability = mean(danceability, na.rm = TRUE),
    energy = mean(energy, na.rm = TRUE),
    instrumentalness = mean(instrumentalness, na.rm = TRUE),
    loudness = mean(loudness, na.rm = TRUE),
    speechiness = mean(speechiness, na.rm = TRUE),
    tempo = mean(tempo, na.rm = TRUE),
    valence = mean(valence, na.rm = TRUE),
    n_tracks = length(duration_ms)
  )
all_tracks_grouped$date <- as.Date(paste(all_tracks_grouped$year, all_tracks_grouped$month, "01", sep = "-"))
missing_months <- list()
missing_month <- all_tracks_grouped[1, ]
for (i in 1:(nrow(all_tracks_grouped) - 1)) {
  if (all_tracks_grouped$year[i + 1] == all_tracks_grouped$year[i]) {
    diff_months <- all_tracks_grouped$month[i + 1] - all_tracks_grouped$month[i]
    if (diff_months > 1) {
      missing <- missing_month[1:(diff_months - 1), ]
      missing$year <- all_tracks_grouped$year[i]
      missing$month <- all_tracks_grouped$month[i] + 1:(diff_months - 1)
      missing$acousticness <- all_tracks_grouped$acousticness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$acousticness[i + 1] - all_tracks_grouped$acousticness[i]
      ) / diff_months
      missing$danceability <- all_tracks_grouped$danceability[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$danceability[i + 1] - all_tracks_grouped$danceability[i]
      ) / diff_months
      missing$energy <- all_tracks_grouped$energy[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$energy[i + 1] - all_tracks_grouped$energy[i]
      ) / diff_months
      missing$instrumentalness <- all_tracks_grouped$instrumentalness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$instrumentalness[i + 1] - all_tracks_grouped$instrumentalness[i]
      ) / diff_months
      missing$loudness <- all_tracks_grouped$loudness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$loudness[i + 1] - all_tracks_grouped$loudness[i]
      ) / diff_months
      missing$speechiness <- all_tracks_grouped$speechiness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$speechiness[i + 1] - all_tracks_grouped$speechiness[i]
      ) / diff_months
      missing$tempo <- all_tracks_grouped$tempo[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$tempo[i + 1] - all_tracks_grouped$tempo[i]
      ) / diff_months
      missing$valence <- all_tracks_grouped$valence[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$valence[i + 1] - all_tracks_grouped$valence[i]
      ) / diff_months
      missing$n_tracks <- 0
      missing$date <- as.Date(paste(missing$year, missing$month, "01", sep = "-"))
      missing_months <- list.append(
        missing_months,
        missing
      )
    }
  } else {
    if (!(all_tracks_grouped$month[i] == 12 && all_tracks_grouped$month[i + 1] == 1)) {
      diff_months <- 12 + all_tracks_grouped$month[i + 1] - all_tracks_grouped$month[i]
      missing <- missing_month[1:(diff_months - 1), ]
      missing$year <- all_tracks_grouped$year[i] + 1
      missing$month <- all_tracks_grouped$month[i] + 1:(diff_months - 1) - 12
      missing$acousticness <- all_tracks_grouped$acousticness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$acousticness[i + 1] - all_tracks_grouped$acousticness[i]
      ) / diff_months
      missing$danceability <- all_tracks_grouped$danceability[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$danceability[i + 1] - all_tracks_grouped$danceability[i]
      ) / diff_months
      missing$energy <- all_tracks_grouped$energy[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$energy[i + 1] - all_tracks_grouped$energy[i]
      ) / diff_months
      missing$instrumentalness <- all_tracks_grouped$instrumentalness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$instrumentalness[i + 1] - all_tracks_grouped$instrumentalness[i]
      ) / diff_months
      missing$loudness <- all_tracks_grouped$loudness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$loudness[i + 1] - all_tracks_grouped$loudness[i]
      ) / diff_months
      missing$speechiness <- all_tracks_grouped$speechiness[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$speechiness[i + 1] - all_tracks_grouped$speechiness[i]
      ) / diff_months
      missing$tempo <- all_tracks_grouped$tempo[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$tempo[i + 1] - all_tracks_grouped$tempo[i]
      ) / diff_months
      missing$valence <- all_tracks_grouped$valence[i] + 1:(diff_months - 1) * (
        all_tracks_grouped$valence[i + 1] - all_tracks_grouped$valence[i]
      ) / diff_months
      missing$n_tracks <- 0
      missing$date <- as.Date(
        paste(missing$year, missing$month, "01", sep = "-")
        )
      missing_months <- list.append(
        missing_months,
        missing
      )
    }
  }
}
all_tracks_grouped <- rbind(
  all_tracks_grouped,
  Reduce(rbind, missing_months)
)
all_tracks_grouped <- all_tracks_grouped[order(all_tracks_grouped$date), ]
all_tracks_grouped$quarter <- ifelse(
  all_tracks_grouped$month <= 3,
  "Q1",
  ifelse(
    all_tracks_grouped$month <= 6,
    "Q2",
    ifelse(
      all_tracks_grouped$month <= 9,
      "Q3",
      "Q4"
    )
  )
)
all_tracks_grouped_quarter <- all_tracks_grouped %>%
  group_by(
    year, quarter
  ) %>%
  dplyr::summarise(
    acousticness = sum(acousticness * n_tracks) / sum(n_tracks),
    danceability = sum(danceability * n_tracks) / sum(n_tracks),
    energy = sum(energy * n_tracks) / sum(n_tracks),
    instrumentalness = sum(instrumentalness * n_tracks) / sum(n_tracks),
    speechiness = sum(speechiness * n_tracks) / sum(n_tracks),
    valence = sum(valence * n_tracks) / sum(n_tracks)
  )
all_tracks_grouped_quarter$date <- paste(
  all_tracks_grouped_quarter$quarter,
  all_tracks_grouped_quarter$year
)


all_tracks_clust <- all_tracks[, c(
  "track.artists",
  "track.name",
  "danceability",
  "energy",
  "speechiness",
  "acousticness",
  "instrumentalness",
  "valence"
)]
task <- makeClusterTask(
  data = all_tracks_clust[, 3:8]
)
learner <- makeLearner(
  "cluster.kmeans",
  centers = 10
)

model <- train(learner, task)
all_tracks_clust$cluster <- model$learner.model$cluster
clustered <- all_tracks_clust %>%
  group_by(
    cluster
  ) %>%
  dplyr::summarise(
    acousticness = mean(acousticness, na.rm = TRUE),
    danceability = mean(danceability, na.rm = TRUE),
    energy = mean(energy, na.rm = TRUE),
    instrumentalness = mean(instrumentalness, na.rm = TRUE),
    speechiness = mean(speechiness, na.rm = TRUE),
    valence = mean(valence, na.rm = TRUE),
    cluster_size = length(cluster)
  )
clustered$tracks[clustered$cluster == 1] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 1, ]$track.name
)
clustered$artists[clustered$cluster == 1] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 1, ]$track.artists
)
clustered$tracks[clustered$cluster == 2] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 2, ]$track.name
)
clustered$artists[clustered$cluster == 2] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 2, ]$track.artists
)
clustered$tracks[clustered$cluster == 3] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 3, ]$track.name
)
clustered$artists[clustered$cluster == 3] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 3, ]$track.artists
)
clustered$tracks[clustered$cluster == 4] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 4, ]$track.name
)
clustered$artists[clustered$cluster == 4] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 4, ]$track.artists
)
clustered$tracks[clustered$cluster == 5] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 5, ]$track.name
)
clustered$artists[clustered$cluster == 5] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 5, ]$track.artists
)
clustered$tracks[clustered$cluster == 6] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 6, ]$track.name
)
clustered$artists[clustered$cluster == 6] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 6, ]$track.artists
)
clustered$tracks[clustered$cluster == 7] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 7, ]$track.name
)
clustered$artists[clustered$cluster == 7] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 7, ]$track.artists
)
clustered$tracks[clustered$cluster == 8] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 8, ]$track.name
)
clustered$artists[clustered$cluster == 8] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 8, ]$track.artists
)
clustered$tracks[clustered$cluster == 9] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 9, ]$track.name
)
clustered$artists[clustered$cluster == 9] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 9, ]$track.artists
)
clustered$tracks[clustered$cluster == 10] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 10, ]$track.name
)
clustered$artists[clustered$cluster == 10] <- as.data.frame(
  all_tracks_clust[all_tracks_clust$cluster == 10, ]$track.artists
)
