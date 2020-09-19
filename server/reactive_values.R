art_number <- reactiveValues(click = 1)
# create the reactive values in which we will store the data relating to
# an artist
# first the general values
art_infos <- reactiveValues(
  genre = "",
  popularity = "",
  followers = "",
  albums = "",
  songs = "",
  related = "",
  image = "",
  name = ""
)
# now the song specific values
song_infos <- reactiveValues(
  most_popular_songs = data.frame(
    name = NA,
    popularity = NA
  ),
  least_popular_songs = data.frame(
    name = NA,
    popularity = NA
  ),
  audio_features = data.frame(
    danceability = NA,
    energy = NA,
    loudness = NA,
    speechiness = NA,
    acousticness = NA,
    instrumentalness = NA,
    liveness = NA,
    valence = NA,
    tempo = NA,
    duration_ms = NA,
    track_name = NA,
    minutes = NA,
    seconds = NA
  )
)
# now the album specific values
album_infos <- reactiveValues(
  most_popular_albums = list(
    data.frame(
      NA
    )
  ),
  least_popular_albums = list(
    data.frame(
      NA
    )
  ),
  album_features = data.frame(
    length = NA,
    acousticness = NA,
    danceability = NA,
    energy = NA,
    instrumentalness = NA,
    loudness = NA,
    speechiness = NA,
    valence = NA,
    tempo = NA,
    release_date = NA,
    name = NA
  )
)
# get the values for the artist clicked
shinyjs::onclick("artist_at_1", function(x) {
  i <- 1
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 1 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_2", function(x) {
  i <- 2
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 2 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_3", function(x) {
  i <- 3
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 3 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_4", function(x) {
  i <- 4
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 4 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_5", function(x) {
  i <- 5
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 5 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_6", function(x) {
  i <- 6
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 6 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_7", function(x) {
  i <- 7
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 7 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_8", function(x) {
  i <- 8
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 8 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_9", function(x) {
  i <- 9
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 9 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_10", function(x) {
  i <- 10
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 10 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_11", function(x) {
  i <- 11
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 11 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_12", function(x) {
  i <- 12
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 12 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_13", function(x) {
  i <- 13
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 13 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_14", function(x) {
  i <- 14
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 14 finished")
  # show the modal
  show_modal()
})
shinyjs::onclick("artist_at_15", function(x) {
  i <- 15
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
  # get the most popular album(s)
  album_infos$most_popular_albums <- album_data[
    album_data$popularity == max(album_data$popularity),
    c("name", "popularity", "images")
  ]
  # get the least popular album(s)
  album_infos$least_popular_albums <- album_data[
    album_data$popularity == min(album_data$popularity),
    c("name", "popularity", "images")
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
        name = x$album_name
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
  # get the ids of each song
  song_ids <- audio_features$track_id
  # split into lists of 50 (max request size)
  n <- length(song_ids)
  k <- 50
  a <- split(song_ids, rep(1:ceiling(n / k), each = k)[1:n])
  # get the tracks
  features <- lapply(a, function(x) {
    features <- get_tracks(x)[, c("name", "popularity")]
  })
  # bind it all together
  songs_popularity <- Reduce(rbind, features)
  # get the most and least popular songs
  songs_popularity <- songs_popularity[songs_popularity$popularity > 0, ]
  song_infos$most_popular_songs <- songs_popularity[
    songs_popularity$popularity == max(songs_popularity$popularity),
  ]
  song_infos$least_popular_songs <- songs_popularity[
    songs_popularity$popularity == min(songs_popularity$popularity),
  ]
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
    "track_name", "minutes", "seconds"
  )]
  # get the audio features
  song_infos$audio_features <- audio_features
  print("Artist 15 finished")
  # show the modal
  show_modal()
})
