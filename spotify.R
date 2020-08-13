library(spotifyr)
library(dotenv)
library(lubridate)
library(dplyr)
library(knitr)
library(tidyverse)
load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
# first get your all time top 20 artists:
get_my_top_artists_or_tracks(type = 'artists', time_range = 'long_term', limit = 20) %>% 
  select(name, genres) %>% 
  rowwise %>% 
  mutate(genres = paste(genres, collapse = ', ')) %>% 
  ungroup

# compare to your recent top 20 artists:
get_my_top_artists_or_tracks(type = 'artists', time_range = 'short_term', limit = 20) %>% 
  select(name, genres) %>% 
  rowwise %>% 
  mutate(genres = paste(genres, collapse = ', ')) %>% 
  ungroup

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
get_my_top_artists_or_tracks(type = 'tracks', time_range = 'long_term', limit = 20) %>% 
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>% 
  select(name, artist.name, album.name)

# recently favs
get_my_top_artists_or_tracks(type = 'tracks', time_range = 'short_term', limit = 20) %>% 
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>% 
  select(name, artist.name, album.name)

get_related_artists(artist$artist_id[1])
get_my_currently_playing()