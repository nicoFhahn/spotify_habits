load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
code <- get_spotify_authorization_code()
# first get your all time top artists:
longterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "long_term",
  limit = 40,
  authorization = code
)
shortterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "short_term",
  limit = 40,
  authorization = code
)
longterm_tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  time_range = "long_term",
  limit = 40,
  authorization = code
)
shortterm_tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  time_range = "short_term",
  limit = 40,
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