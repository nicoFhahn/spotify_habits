get_artist_features <- function(i, artists) {
  art_infos <- list()
  # get the rank
  art_infos$place <- i
  # get the genre
  art_infos$genre <- artists$genres[[i]][1]
  # get the popularity
  art_infos$popularity <- artists$popularity[i]
  # get the number of followers
  art_infos$followers <- artists$followers.total[i]
  # get the albums
  albums <- get_artist_albums(artists$id[i], include_groups = "album")
  if (is.null(nrow(albums))) {
    art_infos$albums <- 0
    album_data <- data.frame()
    album_data_old <- data.frame()
  } else {
    # deduplicate the album bames
    albums <- dedupe_album_names(
      albums,
      album_name_col = "name",
      album_release_year_col = "release_date"
    )
    # get the number of remaining albums
    art_infos$albums <- nrow(albums)
  }
  # get the audio features of all the songs
  audio_features <- get_artist_audio_features(
    artists$id[i],
    include_groups = c("single", "album")
  )
  # get the number of songs
  art_infos$songs <- nrow(audio_features)
  # get the related artists
  art_infos$related <- get_related_artists(artists$id[i])$name[1:5]
  # get the artist image
  art_infos$image <- artists$images[[i]][, 2][1]
  # get the artist name
  art_infos$name <- artists$name[i]
  # get the album data
  if (!is.null(nrow(albums))) {
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
  audio_features <- audio_features[audio_features$album_type == "album", ]
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
    id_2 <- sample(most_popular_albums$id, 1)
  }
  # get the uri
  uri_2 <- create_uri(
    album_data_old[album_data_old$id == id_2, ]$uri,
    iframe_skeleton
  )
  # get random covers of the albums on page 4
  id_3 <- c(
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
    get_tracks(x)[, c("name", "popularity", "uri")]
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
  # get the number of minutes and seconds of a song
  times <- get_minutes_and_seconds(audio_features)
  audio_features$minutes <- times$minutes
  audio_features$seconds <- times$seconds
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
  # remove itunes interviews
  audio_features <- audio_features[!str_detect(
    audio_features$track_name, "iTunes Originals Interview"
  ), ]
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

get_audio_features_top <- function(artists) {
  audio_features <- lapply(
    artists$id,
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
  Reduce(rbind, audio_features)
}

create_random_grid <- function(urls, type) {
  # dran random sample
  sample_numbers <- sample(1:28, size = length(urls))
  # skeleton for the grid
  skeleton <- c(
    '<div class="area1"></div>',
    '<div class="area2"></div>',
    '<div class="area3"></div>',
    '<div class="area4"></div>',
    '<div class="area5"></div>',
    '<div class="area6 "></div>',
    '<div class="area7 "></div>',
    '<div class="area8 "></div>',
    '<div class="area9 "></div>',
    '<div class="area10 "></div>',
    '<div class="area11 "></div>',
    '<div class="area12 "></div>',
    '<div class="area13 "></div>',
    '<div class="area14 "></div>',
    '<div class="area15 "></div>',
    '<div class="area16 "></div>',
    '<div class="area17 "></div>',
    '<div class="area18 "></div>',
    '<div class="area19 "></div>',
    '<div class="area20 "></div>',
    '<div class="area21 "></div>',
    '<div class="area22 "></div>',
    '<div class="area23 "></div>',
    '<div class="area24 "></div>',
    '<div class="area25 "></div>',
    '<div class="area26 "></div>',
    '<div class="area27 "></div>',
    '<div class="area28 "></div>'
  )
  skeleton_images <- c()
  urls_old <- urls
  for (x in skeleton) {
    # get the number of the current area
    number <- as.numeric(str_extract(x, "[0-9]{1,2}"))
    # check if it is in the sample
    if (number %in% sample_numbers) {
      # if yes draw a random image
      cover <- sample(urls, 1)
      # add the correct artist id
      id_first <- paste("artist_", type, "_", sep = "")
      id <- paste(id_first, match(cover, urls_old), sep = "")
      urls <- urls[!urls %in% cover]
      # create the new html tag
      skeleton_images <- c(
        skeleton_images,
        str_replace(
          x,
          "><",
          paste(
            '><img class = "hidden2" id = "',
            # '><img id = "',
            id,
            '" src = "',
            cover,
            '"><',
            sep = ""
          )
        )
      )
    } else {
      skeleton_images <- c(
        skeleton_images,
        x
      )
    }
  }
  # paste it all together
  paste(
    "<div id = 'grid-container-id' class = 'grid-container'>",
    paste(unlist(skeleton_images), collapse = ""),
    "</div>"
  )
}

skeleton_replacer <- function(i, df, table_skeleton, urls) {
  # replace certain parts of the table skeleton
  table_skeleton <- str_replace(
    table_skeleton,
    "rank_1",
    paste("#", i[1], sep = "")
  )
  table_skeleton <- str_replace(
    table_skeleton,
    "rank_2",
    paste("#", i[2], sep = "")
  )
  table_skeleton <- str_replace(
    table_skeleton,
    "name_1",
    df$name[i[1]]
  )
  table_skeleton <- str_replace(
    table_skeleton,
    "name_2",
    df$name[i[2]]
  )
  table_skeleton <- str_replace(
    table_skeleton,
    "img_1",
    paste("<img class='table_image' src='", urls[i[1]], "'>", sep = "")
  )
  table_skeleton <- str_replace(
    table_skeleton,
    "img_2",
    paste("<img class='table_image' src='", urls[i[2]], "'>", sep = "")
  )
  table_skeleton
}

add_id <- function(html, id) {
  # split by the class tag
  html_split <- str_split(
    html,
    "class='col_name'"
  )
  places <- unlist(lapply(seq_len(10), seq, to = 20, by = 10))
  # add the correct ids for each
  html_id_added <- lapply(seq_len(20), function(x, ...) {
    paste(
      "class='col_name' id='",
      id,
      "_",
      places[x],
      "'",
      html_split[[1]][x + 1],
      sep = ""
    )
  })
  # paste it all together
  paste(html_split[[1]][1], Reduce(paste, html_id_added))
}

get_minutes_and_seconds <- function(dataframe) {
  minutes <- unlist(
    lapply(
      dataframe$duration_ms,
      function(x) {
        as.numeric(
          str_extract(
            x / 60000,
            "[0-9]{1,}"
          )
        )
      }
    )
  )

  seconds <- unlist(
    lapply(
      dataframe$duration_ms,
      function(x) {
        seconds <- round(
          as.numeric(
            str_extract(
              x / 60000,
              "\\.[0-9]{1,}"
            )
          ),
          2
        )
        if (is.na(seconds)) {
          seconds <- 0
        }
        seconds <- round(seconds * 60)
        if (!str_detect(seconds, "[0-9]{2}")) {
          seconds <- paste("0", seconds, sep = "")
        }
        seconds
      }
    )
  )
  list(
    minutes = minutes,
    seconds = seconds
  )
}

get_track_infos <- function(i, tracks, ...) {
  values <- list()
  # get the name
  values$artists <- tracks$artists[[i]]$name
  # get the title
  values$title <- tracks$name[i]
  # get the album
  values$album <- tracks$album.name[i]
  # get the popularity
  values$popularity <- tracks$popularity[i]
  # get whether its explicit
  values$explicit <- tracks$explicit[i]
  # get the album image
  values$image <- tracks$album.images[[i]][, 2][1]
  # get the place
  values$place <- i
  times <- get_minutes_and_seconds(tracks[i, ])
  values$minutes <- times$minutes
  values$seconds <- times$seconds
  values$uri <- create_uri(tracks$uri[i], iframe_skeleton)
  return(values)
}

get_track_details <- function(i, tracks) {
  values <- list()
  # get the audio features
  audio_features <- get_track_audio_features(tracks$id[i])
  # get the acousticness
  values$acousticness <- audio_features$acousticness
  # get the instrumentalness
  values$instrumentalness <- audio_features$instrumentalness
  # get the energy
  values$energy <- audio_features$energy
  # get the danceability
  values$danceability <- audio_features$danceability
  # get the loudness
  values$loudness <- audio_features$loudness
  # get the tempo
  values$tempo <- audio_features$tempo
  # get the valence
  values$valence <- audio_features$valence
  # get the liveness
  values$liveness <- audio_features$liveness
  # get the speechiness
  values$speechiness <- audio_features$speechiness
  return(values)
}

get_similar_songs <- function(i, tracks, details) {
  recommendations <- get_recommendations(
    limit = 6,
    seed_tracks = tracks$id[i],
    seed_artists = tracks$artists[[i]]$id,
    target_acousticness = details$acousticness,
    target_instrumentalness = details$instrumentalness,
    target_loudness = details$loudness,
    target_speechiness = details$speechiness,
    target_tempo = details$tempo
  )
  values <- lapply(recommendations$uri, create_uri, iframe_skeleton)
  names(values) <- paste("uri_", seq_len(6), sep = "")
  return(values)
}

get_all_saved_stuff <- function() {
  tracks <- list()
  # get all the saved tracks
  new_tracks <- get_my_saved_tracks(
    limit = 50,
    offset = 0
  )
  offset <- 50
  tracks <- list.append(
    tracks,
    new_tracks
  )
  # download while there are still tracks available
  while (length(new_tracks) > 0) {
    offset <- offset + 50
    new_tracks <- get_my_saved_tracks(
      limit = 50,
      offset = offset
    )
    tracks <- list.append(
      tracks,
      new_tracks
    )
  }
  # bind together
  tracks <- Reduce(rbind, tracks)
  playlists <- list()
  # now do the same for all the playlists
  new_playlists <- get_my_playlists(
    limit = 50,
    offset = 0
  )
  offset <- 50
  playlists <- list.append(
    playlists,
    new_playlists
  )
  while (length(new_playlists) > 0) {
    offset <- offset + 50
    new_playlists <- get_my_playlists(
      limit = 50,
      offset = offset
    )
    playlists <- list.append(
      playlists,
      new_playlists
    )
  }
  # bind them together
  playlists <- Reduce(rbind, playlists)
  # keep only the playlist that are made by the user
  playlists <- playlists[playlists$owner.id == get_my_profile()$id, ]
  playlist_tracks <- list()
  # now get the tracks out of all these playlists
  playlist_tracks <- lapply(
    playlists$id,
    function(x) {
      tracks <- list()
      new_tracks <- get_playlist_tracks(
        playlist_id = x,
        limit = 100,
        offset = 0
      )
      offset <- 100
      tracks <- list.append(
        tracks,
        new_tracks
      )
      while (length(new_tracks) > 0) {
        offset <- offset + 100
        new_tracks <- get_playlist_tracks(
          playlist_id = x,
          limit = 100,
          offset = offset
        )
        tracks <- list.append(
          tracks,
          new_tracks
        )
      }
      tracks <- Reduce(rbind, tracks)
    }
  )
  # bind everything together
  playlist_tracks <- Reduce(rbind, playlist_tracks)
  # keep relevant information
  tracks <- tracks[, c(
    "added_at",
    "track.artists",
    "track.name",
    "track.id",
    "track.popularity"
  )]
  playlist_tracks <- playlist_tracks[, c(
    "added_at",
    "track.artists",
    "track.name",
    "track.id",
    "track.popularity"
  )]
  all_tracks <- rbind(
    tracks,
    playlist_tracks
  )
  # deduplicate the tracks
  all_tracks <- all_tracks[
    !duplicated(all_tracks$track.id),
  ]
  # get the artists
  all_tracks$track.artists <- unlist(
    lapply(
      all_tracks$track.artists,
      function(x) paste(x$name, collapse = ", ")
    )
  )
  # get the ids
  ids <- split(
    all_tracks$track.id,
    rep(
      1:ceiling(nrow(all_tracks) / 100),
      each = 100
    )[seq_len(nrow(all_tracks))]
  )
  # get the all the audio features
  audio_features <- lapply(
    ids,
    get_track_audio_features
  )
  audio_features_df <- Reduce(rbind, audio_features)
  # return one df with all the info
  cbind(
    all_tracks,
    audio_features_df
  )
}

update_values <- function(i, ...) {
  clust_number$val[i] <- !clust_number$val[i]
  num_clicks$val[i] <- num_clicks$val[i] + 1
  if (num_clicks$val[i] %% 2 == 0) {
    sample_songs$val[[i]] <- sample(
      length(clustered[clustered$cluster == i, ]$tracks[[1]]),
      3
    )
  }
}

generate_playlist <- function(shortterm_tracks, longterm_tracks, name = "Wow such name") {
  # take your top 20 tracks
  short_list <- split(shortterm_tracks[1:20, ], shortterm_tracks[1:20, ]$id)
  # get the artists id and song id of each song
  short_pairs <- lapply(short_list, function(x) {
    list(
      "artist_id" = unlist(lapply(x$artists, function(x) x$id)),
      "song_id" = x$id
    )
  })
  # get recommendations for new songs
  recommendations_short <- lapply(
    short_pairs,
    function(x) {
      get_recommendations(
        limit = 20,
        seed_artists = x$artist_id,
        seed_tracks = x$song_id
      )
    }
  )
  # remove songs that appear in most listened to
  recommendations_short <- lapply(
    recommendations_short,
    function(x) {
      x[!x$id %in% c(longterm_tracks$id, shortterm_tracks$id), ]
    }
  )
  # use more songs that are recommended based on your most listened to songs
  songs_short <- lapply(
    seq_len(20),
    function(x, ...) {
      if (x <= 5) {
        recommendations_short[[x]][1:4, ]
      } else if (x <= 10) {
        recommendations_short[[x]][1:3, ]
      } else if (x <= 15) {
        recommendations_short[[x]][1:2, ]
      } else {
        recommendations_short[[x]][1, ]
      }
    }
  )
  # bind everything together
  songs_short <- do.call(rbind, songs_short)
  # now do the same again
  long_list <- split(longterm_tracks[1:20, ], longterm_tracks[1:20, ]$id)
  long_pairs <- lapply(long_list, function(x) {
    list(
      "artist_id" = unlist(lapply(x$artists, function(x) x$id)),
      "song_id" = x$id
    )
  })
  recommendations_long <- lapply(
    long_pairs,
    function(x) {
      get_recommendations(
        limit = 20,
        seed_artists = x$artist_id,
        seed_tracks = x$song_id
      )
    }
  )
  
  # remove songs that appear in most listened to
  recommendations_long <- lapply(
    recommendations_long,
    function(x) {
      x[!x$id %in% c(longterm_tracks$id, shortterm_tracks$id), ]
    }
  )
  songs_long <- lapply(
    seq_len(20),
    function(x, ...) {
      if (x <= 5) {
        recommendations_long[[x]][1:4, ]
      } else if (x <= 10) {
        recommendations_long[[x]][1:3, ]
      } else if (x <= 15) {
        recommendations_long[[x]][1:2, ]
      } else {
        recommendations_long[[x]][1, ]
      }
    }
  )
  songs_long <- do.call(rbind, songs_long)
  songs_all <- rbind(songs_short, songs_long)
  # create a playlist
  create_playlist(
    get_my_profile()$id,
    name = name
  )
  # add the tracks
  add_tracks_to_playlist(
    get_my_playlists()[1, ]$id,
    uris = songs_all$uri
  )
  get_my_playlists()[1, ]$uri
}
