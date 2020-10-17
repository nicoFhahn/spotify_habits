art_number <- reactiveValues(click = 1)
# create the reactive values in which we will store the data relating to
# an artist
# first the general values
art_infos <- reactiveValues(
  values = list(
    genre = "",
    popularity = "",
    followers = "",
    albums = "",
    songs = "",
    related = "",
    image = "",
    name = "",
    place = ""
  )
)

# now the song specific values
song_infos <- reactiveValues(
  values = list(
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
    ),
    iframe_2 = "",
    iframe_3 = ""
  )
)
# now the album specific values
album_infos <- reactiveValues(
  values = list(
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
)
# get the values for the artist clicked
shinyjs::onclick("artist_at_1", function(x) {
  i <- 1
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_2", function(x) {
  i <- 2
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_3", function(x) {
  i <- 3
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_4", function(x) {
  i <- 4
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_5", function(x) {
  i <- 5
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_6", function(x) {
  i <- 6
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_7", function(x) {
  i <- 7
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_8", function(x) {
  i <- 8
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_9", function(x) {
  i <- 9
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_10", function(x) {
  i <- 10
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_11", function(x) {
  i <- 11
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_12", function(x) {
  i <- 12
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_13", function(x) {
  i <- 13
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_14", function(x) {
  i <- 14
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_15", function(x) {
  i <- 15
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_16", function(x) {
  i <- 16
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_17", function(x) {
  i <- 17
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_18", function(x) {
  i <- 18
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_19", function(x) {
  i <- 19
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_at_20", function(x) {
  i <- 20
  if (!local) {
    infos <- get_artist_features(i, longterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_at[[i]]$infos
    albums <- artist_at[[i]]$albums
    songs <- artist_at[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

# get the values for the artist clicked
shinyjs::onclick("artist_rc_1", function(x) {
  i <- 1
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_2", function(x) {
  i <- 2
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_3", function(x) {
  i <- 3
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_4", function(x) {
  i <- 4
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  print("Artist 4 finished")
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_5", function(x) {
  i <- 5
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_6", function(x) {
  i <- 6
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_7", function(x) {
  i <- 7
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_8", function(x) {
  i <- 8
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_9", function(x) {
  i <- 9
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_10", function(x) {
  i <- 10
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_11", function(x) {
  i <- 11
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_12", function(x) {
  i <- 12
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_13", function(x) {
  i <- 13
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_14", function(x) {
  i <- 14
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_15", function(x) {
  i <- 15
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_16", function(x) {
  i <- 16
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_17", function(x) {
  i <- 17
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_18", function(x) {
  i <- 18
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_19", function(x) {
  i <- 19
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

shinyjs::onclick("artist_rc_20", function(x) {
  i <- 20
  if (!local) {
    infos <- get_artist_features(i, shortterm_art)
    album_data <- infos$album_data
    album_data_old <- infos$album_data_old
    audio_features <- infos$audio_features
    if (nrow(album_data) > 0) {
      albums <- get_album_features(album_data, audio_features, album_data_old)
    }
    songs <- get_song_features(audio_features)
  } else {
    infos <- artist_rc[[i]]$infos
    albums <- artist_rc[[i]]$albums
    songs <- artist_rc[[i]]$songs
  }
  art_infos$values <- infos$art_infos
  album_infos$values <- albums
  song_infos$values <- songs
  # show the modal
  show_modal(type = "artist")
})

track_infos <- reactiveValues(
  values = list(
    artists = "",
    title = "",
    album = "",
    popularity = "",
    explicit = "",
    image = "",
    place = "",
    minutes = "",
    seconds = "",
    uri = ""
  )
)

track_details <- reactiveValues(
  values = list(
    acousticness = "",
    instrumentalness = "",
    energy = "",
    danceability = "",
    loudness = "",
    tempo = "",
    valence = "",
    liveness = "",
    speechiness = ""
  )
)

track_analysis <- reactiveValues(
  values = list()
)

uri_sim <- reactiveValues(
  values = list(
    uri_1 = "",
    uri_2 = "",
    uri_3 = "",
    uri_4 = "",
    uri_5 = "",
    uri_6 = ""
  )
)

shinyjs::onclick("alltime_songs_1", function(x) {
  i <- 1
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_2", function(x) {
  i <- 2
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_3", function(x) {
  i <- 3
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_4", function(x) {
  i <- 4
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_5", function(x) {
  i <- 5
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_6", function(x) {
  i <- 6
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_7", function(x) {
  i <- 7
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_8", function(x) {
  i <- 8
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_9", function(x) {
  i <- 9
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_10", function(x) {
  i <- 10
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_11", function(x) {
  i <- 11
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_12", function(x) {
  i <- 12
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_13", function(x) {
  i <- 13
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_14", function(x) {
  i <- 14
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_15", function(x) {
  i <- 15
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_16", function(x) {
  i <- 16
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_17", function(x) {
  i <- 17
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_18", function(x) {
  i <- 18
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_19", function(x) {
  i <- 19
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("alltime_songs_20", function(x) {
  i <- 20
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, longterm_tracks)
    details <- get_track_details(i, longterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(longterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      longterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_at[[i]]$infos
    track_details$values <- songs_at[[i]]$details
    track_analysis$values <- songs_at[[i]]$track_analysis
    uri_sim$values <- songs_at[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_1", function(x) {
  i <- 1
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_2", function(x) {
  i <- 2
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_3", function(x) {
  i <- 3
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_4", function(x) {
  i <- 4
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_5", function(x) {
  i <- 5
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_6", function(x) {
  i <- 6
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_7", function(x) {
  i <- 7
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_8", function(x) {
  i <- 8
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_9", function(x) {
  i <- 9
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_10", function(x) {
  i <- 10
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_11", function(x) {
  i <- 11
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_12", function(x) {
  i <- 12
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_13", function(x) {
  i <- 13
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_14", function(x) {
  i <- 14
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_15", function(x) {
  i <- 15
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_16", function(x) {
  i <- 16
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_17", function(x) {
  i <- 17
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_18", function(x) {
  i <- 18
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_19", function(x) {
  i <- 19
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})

shinyjs::onclick("recent_songs_20", function(x) {
  i <- 20
  # get the track infos
  if (!local) {
    infos <- get_track_infos(i, shortterm_tracks)
    details <- get_track_details(i, shortterm_tracks)
    track_infos$values <- infos
    track_details$values <- details
    track_analysis$values <- get_track_audio_analysis(shortterm_tracks$id[i])
    uri_sim$values <- get_similar_songs(
      i,
      shortterm_tracks,
      track_details$values
    )
  } else {
    track_infos$values <- songs_rc[[i]]$infos
    track_details$values <- songs_rc[[i]]$details
    track_analysis$values <- songs_rc[[i]]$track_analysis
    uri_sim$values <- songs_rc[[i]]$uri_sim
  }
  show_modal(type = "song")
})


clicked <- reactiveValues(
  last = "Acousticness"
)

shinyjs::onclick("acoust", {
  clicked$last <- "Acousticness"
})

shinyjs::onclick("dance", {
  clicked$last <- "Danceability"
})

shinyjs::onclick("energy", {
  clicked$last <- "Energy"
})

shinyjs::onclick("instrument", {
  clicked$last <- "Instrumentalness"
})

shinyjs::onclick("live", {
  clicked$last <- "Liveness"
})

shinyjs::onclick("loud", {
  clicked$last <- "Loudness"
})

shinyjs::onclick("speech", {
  clicked$last <- "Speechiness"
})

shinyjs::onclick("tempo", {
  clicked$last <- "Tempo"
})

shinyjs::onclick("valence", {
  clicked$last <- "Valence"
})
