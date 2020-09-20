get_artist_features <- function(i, ...) {
  art_infos <- list()
  # get the rank
  art_infos$place <- i
  # get the genre
  art_infos$genre <- longterm_art$genres[[i]][1]
  # get the popularity
  art_infos$popularity <- longterm_art$popularity[i]
  # get the number of followers
  art_infos$followers <- longterm_art$followers.total[i]
  # get the albums
  albums <- get_artist_albums(longterm_art$id[i], include_groups = "album")
  # deduplicate the album bames
  albums <- dedupe_album_names(
    albums,
    album_name_col = "name",
    album_release_year_col = "release_date"
  )
  # get the number of remaining albums
  art_infos$albums <- nrow(albums)
  # get the audio features of all the songs
  audio_features <- get_artist_audio_features(longterm_art$id[i])
  # get the number of songs
  art_infos$songs <- nrow(audio_features)
  # get the related artists
  art_infos$related <- get_related_artists(longterm_art$id[i])$name[1:5]
  # get the artist image
  art_infos$image <- longterm_art$images[[i]][, 2][1]
  # get the artist name
  art_infos$name <- longterm_art$name[i]
  # get the album data
  album_data <- get_albums(albums$id)
  # save for later
  album_data_old <- album_data
  # manual deduplication
  dupes <- unique(album_data$name[duplicated(album_data$name)])
  if (length(dupes) > 0) {
    album_dupes <- lapply(dupes, function(x, ...) {
      # get the dupes
      dupes <- album_data[album_data$name %in% x, ]
      # keep the most popular one
      dupes <- dupes[dupes$popularity == max(dupes$popularity), ]
      # if there is still more than the most tracks
      if (nrow(dupes) > 1) {
        dupes <- dupes[dupes$tracks.total == max(dupes$tracks.total), ]
      }
      # now just choose one
      if (nrow(dupes) > 1) {
        dupes <- dupes[1, ]
      }
      dupes
    })
    # bind them together
    album_dupes <- Reduce(rbind, album_dupes)
    album_data <- album_data[!album_data$name %in% dupes, ]
    album_data <- rbind(album_data, album_dupes)
    art_infos$albums <- nrow(album_data)
  }
  return(list(
    "art_infos" = art_infos,
    "album_data" = album_data,
    "album_data_old" = album_data_old,
    "audio_features" = audio_features
  ))
}

get_album_features <- function(album_data, audio_features, album_data_old) {
  album_infos <- list()
  # get the most popular album(s)
  most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "uri", "id")
  ]
  # get the uri
  uri <- create_uri(most_popular_albums$uri[1], iframe_skeleton)
  most_popular_albums$uri <- uri
  album_infos$most_popular_albums <- most_popular_albums
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "uri", "id")
  ]
  # split audio features by album id to calculate the features of each album
  album_features <- split(audio_features, audio_features$album_id)
  # calculate the values for each album
  album_features <- lapply(
    album_features, function(x) {
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
        name = x$album_name,
        id = x$album_id[1]
      )[1, ]
    }
  )
  # bind it all together
  album_features <- Reduce(rbind, album_features)
  # check if any albums have a missing release date
  missing_date <- album_features[
    !str_detect(album_features$release_date, "[0-9]{4}-"),
  ]
  # if so add one
  if (nrow(missing_date) > 0) {
    # remove the albums with a missing date
    album_features[
      !str_detect(album_features$release_date, "[0-9]{4}-"),
    ] <- NA
    album_features <- album_features[complete.cases(album_features), ]
    for (i in seq_len(nrow(missing_date))) {
      # check if the album is already present (sometimes it is for some reason)
      if (missing_date[i, ]$name %in% album_features$name) {
        missing_date[i, ]$release_date <- album_features[
          album_features$name == missing_date$name[i],
        ]$release_date[1]
      } else {
        # else set the middle of the year as the release date
        missing_date[i, ]$release_date <- paste(
          missing_date[i, ]$release_date,
          "-06-30",
          sep = ""
        )
      }
    }
    # bind it all together again
    album_features <- rbind(album_features, missing_date)
    # change column type to date
    album_features$release_date <- as.Date(album_features$release_date)
  }
  # get the album features
  album_infos$album_features <- album_features
  # get random covers of the albums on page 3
  id_2 <- c(
    album_features[
      album_features$acousticness == max(album_features$acousticness),
    ]$id,
    album_features[
      album_features$instrumentalness == max(album_features$instrumentalness),
    ]$id,
    album_features[
      album_features$energy == max(album_features$energy),
    ]$id,
    album_features[
      album_features$energy == min(album_features$energy),
    ]$id,
    album_features[
      album_features$danceability == max(album_features$danceability),
    ]$id,
    album_features[
      album_features$danceability == min(album_features$danceability),
    ]$id
  )
  # get all the available ids
  ids_available <- unique(id_2[id_2 != most_popular_albums$id])
  ids_available <- ids_available[ids_available %in% album_data_old$id]
  if (length(ids_available) > 0) {
    id_2 <- sample(ids_available, 1)
  } else {
    id_2 <- most_popular_albums$id
  }
  # get the uri
  uri_2 <- create_uri(
    album_data_old[album_data_old$id == id_2, ]$uri,
    iframe_skeleton
    )
  # get random covers of the albums on page 4
  id_3 = c(
    album_features[
      album_features$loudness == max(album_features$loudness),
    ]$id,
    album_features[
      album_features$loudness == min(album_features$loudness),
    ]$id,
    album_features[
      album_features$tempo == max(album_features$tempo),
    ]$id,
    album_features[
      album_features$tempo == min(album_features$tempo),
    ]$id,
    album_features[
      album_features$valence == max(album_features$valence),
    ]$id,
    album_features[
      album_features$valence == min(album_features$valence),
    ]$id
  )
  # get all the available ids
  ids_available <- unique(id_3[!id_3 %in% c(id_2, most_popular_albums$id)])
  ids_available <- ids_available[ids_available %in% album_data_old$id]
  if (length(ids_available) > 0) {
    id_3 <- sample(ids_available, 1)
  } else {
    id_3 <- sample(unique(id_2, most_popular_albums$id), 1)
  }
  # get the uri
  uri_3 <- create_uri(
    album_data_old[album_data_old$id == id_3, ]$uri,
    iframe_skeleton
  )
  album_infos$uri_2 <- uri_2
  album_infos$uri_3 <- uri_3
  return(album_infos)
}

get_song_features <- function(audio_features) {
  song_infos <- list()
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity", "uri")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  most_popular_songs$uri <- create_uri(most_popular_songs$uri, iframe_skeleton)
  song_infos$most_popular_songs <- most_popular_songs
  least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
  if (nrow(least_popular_songs) > 5) {
    least_popular_songs <- least_popular_songs[
      sample(seq_len(nrow(least_popular_songs)), 5),
    ]
  }
  least_popular_songs$uri <- create_uri(
    least_popular_songs$uri,
    iframe_skeleton
    )
  song_infos$least_popular_songs <- least_popular_songs
  # for the audio analysis part remove intros and interludes
  audio_features <- audio_features[
    !str_detect(
      audio_features$track_name,
      "(Intro|Interlude)"
    ),
  ]
  # get the number of minutes of a song
  audio_features$minutes <- as.numeric(
    str_extract(audio_features$duration_ms / 60000, "[0-9]{1,}")
  )
  # get the number of seconds of a song
  audio_features$seconds <- round(
    as.numeric(
      str_extract(audio_features$duration_ms / 60000, "\\.[0-9]{1,}")
    )
    * 60
  )
  audio_features$seconds[
    !str_detect(audio_features$seconds, "[0-9]{2}")
  ] <- paste(
    "0",
    audio_features$seconds[!str_detect(audio_features$seconds, "[0-9]{2}")],
    sep = ""
  )
  # important audio features
  audio_features <- audio_features[, c(
    "danceability", "energy", "loudness", "speechiness", "acousticness",
    "instrumentalness", "liveness", "valence", "tempo", "duration_ms",
    "track_name", "minutes", "seconds", "track_uri"
  )]
  # draw random iframes for the song pages
  audio_features$track_uri <- unlist(
    lapply(
      audio_features$track_uri,
      create_uri,
      iframe_skeleton
      )
    )
  songs_2 <- audio_features[
    audio_features$acousticness == max(audio_features$acousticness) |
      audio_features$instrumentalness == max(audio_features$instrumentalness) |
        audio_features$energy %in% range(audio_features$energy) |
          audio_features$danceability %in% range(audio_features$danceability),
  ]
  songs_2 <- songs_2[!duplicated(songs_2$track_name), ]
  songs_3 <- audio_features[
    audio_features$loudness %in% range(audio_features$loudness) |
      audio_features$tempo %in% range(audio_features$tempo) |
      audio_features$valence %in% range(audio_features$valence),
    ]
  songs_3 <- songs_3[!duplicated(songs_3$track_name), ]
  song_infos$iframe_2 <- sample(songs_2$track_uri, 1)
  song_infos$iframe_3 <- sample(songs_3$track_uri, 1)
  # get the audio features
  song_infos$audio_features <- audio_features
  return(song_infos)
}

create_uri <- function(uri, iframe_skeleton) {
  # split the uri
  uri_split <- str_split(uri, ":")
  # get the embed link
  uri <- paste(
    "https://open.spotify.com/embed",
    uri_split[[1]][2],
    uri_split[[1]][3],
    sep = "/"
  )
  uri <- str_replace(iframe_skeleton, "placeholder", uri)
  return(uri)
}
