iframe_skeleton <- c(
  "<iframe src='placeholder' frameborder='0' allowtransparency='true'
  allow='encrypted-media' background='#242424'></iframe>"
)
artist_at <- list()
for (x in 1:50) {
  print(x)
  Sys.sleep(2)
  infos <- get_artist_features(x, longterm_art)
  album_data <- infos$album_data
  album_data_old <- infos$album_data_old
  audio_features <- infos$audio_features
  if (nrow(album_data) > 0) {
    Sys.sleep(2)
    albums <- get_album_features(album_data, audio_features, album_data_old)
  } else {
    albums <- list(
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
        name = NA,
        image = NA
      ),
      uri_2 = "",
      uri_3 = ""
    )
  }
  Sys.sleep(2)
  songs <- get_song_features(audio_features)
  artist_at <- list.append(artist_at, list(
    infos = infos,
    albums = albums,
    songs = songs
  ))
  remove(infos)
  remove(album_data)
  remove(album_data_old)
  remove(audio_features)
  remove(albums)
  remove(songs)
}

artist_rc <- list()
for (x in 1:50) {
  print(x)
  Sys.sleep(2)
  infos <- get_artist_features(x, shortterm_art)
  album_data <- infos$album_data
  album_data_old <- infos$album_data_old
  audio_features <- infos$audio_features
  if (nrow(album_data) > 0) {
    Sys.sleep(2)
    albums <- get_album_features(album_data, audio_features, album_data_old)
  } else {
    albums <- list(
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
        name = NA,
        image = NA
      ),
      uri_2 = "",
      uri_3 = ""
    )
  }
  Sys.sleep(2)
  songs <- get_song_features(audio_features)
  artist_rc <- list.append(artist_rc, list(
    infos = infos,
    albums = albums,
    songs = songs
  ))
  remove(infos)
  remove(album_data)
  remove(album_data_old)
  remove(audio_features)
  remove(albums)
  remove(songs)
}

songs_at <- list()
for (x in 1:50) {
  print(x)
  Sys.sleep(2)
  infos <- get_track_infos(x, longterm_tracks)
  Sys.sleep(2)
  details <- get_track_details(x, longterm_tracks)
  Sys.sleep(2)
  track_analysis <- get_track_audio_analysis(longterm_tracks$id[x])
  Sys.sleep(2)
  uri_sim <- get_similar_songs(x, longterm_tracks, details)
  songs_at <- list.append(
    songs_at,
    list(
      infos = infos,
      details = details,
      track_analysis = track_analysis,
      uri_sim = uri_sim
    )
  )
}

songs_rc <- list()
for (x in 1:50) {
  print(x)
  Sys.sleep(2)
  infos <- get_track_infos(x, shortterm_tracks)
  Sys.sleep(2)
  details <- get_track_details(x, shortterm_tracks)
  Sys.sleep(2)
  track_analysis <- get_track_audio_analysis(shortterm_tracks$id[x])
  Sys.sleep(2)
  uri_sim <- get_similar_songs(x, shortterm_tracks, details)
  songs_rc <- list.append(
    songs_rc,
    list(
      infos = infos,
      details = details,
      track_analysis = track_analysis,
      uri_sim = uri_sim
    )
  )
}

rm(
  all_tracks,
  all_tracks_clust,
  all_tracks_grouped,
  code,
  details,
  learner,
  missing,
  missing_month,
  missing_months,
  model,
  task,
  track_analysis,
  uri_sim,
  access_token,
  diff_months,
  i,
  iframe_skeleton,
  x,
  add_id,
  create_random_grid,
  create_uri,
  get_album_features,
  get_all_saved_stuff,
  get_artist_features,
  get_audio_features_top,
  get_minutes_and_seconds,
  get_similar_songs,
  get_song_features,
  get_track_details,
  get_track_infos,
  skeleton_replacer,
  update_values
)

save.image("files.RData")
