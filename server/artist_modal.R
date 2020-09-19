# define the function that shows the modal
show_modal <- function(...) {
  showModal(
    modalDialog(
      class = "artist_modal",
      title = HTML(
        paste(
          tags$figure(
            tags$image(
              src = art_infos$image
            ),
            tags$figcaption(
              h4(
                art_infos$name
              )
            )
          )
        )
      ),
      easyClose = TRUE,
      footer = NULL,
      tabsetPanel(
        tabPanel(
          title = "General information",
          column(
            width = 10,
            h6(
              "Genre"
            ),
            p(
              art_infos$genre
            ),
            br(),
            h6(
              "Populartiy"
            ),
            p(
              art_infos$popularity
            ),
            br(),
            h6(
              "#Followers"
            ),
            p(
              format(
                art_infos$followers,
                big.interval = 3, big.mark = " "
              )
            ),
            br(),
            h6(
              "#Albums on Spotify"
            ),
            p(
              art_infos$albums
            ),
            br(),
            h6(
              "#Songs on Spotify"
            ),
            p(
              art_infos$songs
            ),
            br(),
            h6(
              "Related artists"
            ),
            p(
              paste(
                art_infos$related,
                collapse = ", "
              )
            )
          )
        ),
        tabPanel(
          "Album Breakdown 1",
          column(
            width = 10,
            h6(
              ifelse(
                nrow(album_infos$most_popular_albums) > 1,
                "Most popular albums",
                "Most popular album"
              )
            ),
            p(
              ifelse(
                nrow(album_infos$most_popular_albums) > 1,
                paste(
                  paste(
                    album_infos$most_popular_albums$name,
                    collapse = ", "
                  ),
                  album_infos$most_popular_albums$popularity,
                  sep = " - "
                ),
                paste(
                  album_infos$most_popular_albums$name,
                  album_infos$most_popular_albums$popularity,
                  sep = " - "
                )
              )
            ),
            br(),
            h6(
              ifelse(
                nrow(album_infos$least_popular_albums) > 1,
                "Least popular albums",
                "Least popular album"
              )
            ),
            p(
              ifelse(
                nrow(album_infos$least_popular_albums) > 1,
                paste(
                  paste(
                    album_infos$least_popular_albums$name,
                    collapse = ", "
                  ),
                  album_infos$least_popular_albums$popularity,
                  sep = " - "
                ),
                paste(
                  album_infos$least_popular_albums$name,
                  album_infos$least_popular_albums$popularity,
                  sep = " - "
                )
              )
            ),
            br(),
            h6(
              "Longest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$length),
                ][
                  nrow(album_infos$album_features),
                ][, 11],
                " - ",
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$length),
                  ][
                    nrow(album_infos$album_features),
                  ][, 1] / 60000
                ),
                " minutes",
                sep = ""
              )
            ),
            br(),
            h6(
              "Shortest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$length),
                ][
                  1,
                ][, 11],
                " - ",
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$length),
                  ][
                    1,
                  ][, 1] / 60000
                ),
                " minutes",
                sep = ""
              )
            ),
            br(),
            h6(
              "Newest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$release_date),
                ][
                  nrow(album_infos$album_features),
                ]$name,
                " (",
                album_infos$album_features[
                  order(album_infos$album_features$release_date),
                ][
                  nrow(album_infos$album_features),
                ]$release_date,
                ")",
                sep = ""
              )
            ),
            br(),
            h6(
              "Oldest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$release_date),
                ][1, ]$name,
                " (",
                album_infos$album_features[
                  order(album_infos$album_features$release_date),
                ][1, ]$release_date,
                ")",
                sep = ""
              )
            )
          ),
          column(
            width = 2,
            img(
              class = "album_cover",
              src = album_infos$most_popular_albums$images[[1]][1, 2]
            ),
            img(
              class = "album_cover",
              src = album_infos$least_popular_albums$images[[1]][1, 2]
            )
          )
        ),
        tabPanel(
          "Album Breakdown 2",
          column(
            width = 10,
            h6(
              "Most acoustic album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$acousticness,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$acousticness,
                      decreasing = TRUE
                      ),
                  ][1, ]$acousticness,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most instrumental album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$instrumentalness,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$instrumentalness,
                      decreasing = TRUE
                      ),
                  ][1, ]$instrumentalness,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most energetic album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$energy,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$energy,
                      decreasing = TRUE
                      ),
                  ][1, ]$energy,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Least energetic album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$energy),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$energy),
                  ][1, ]$energy,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Most danceable album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$danceability,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$danceability,
                      decreasing = TRUE
                      ),
                  ][1, ]$danceability,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Least danceable album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$danceability),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$danceability),
                  ][1, ]$danceability,
                  3
                ),
                sep = " - "
              )
            )
          ),
          column(
            width = 2
          )
        ),
        tabPanel(
          "Album Breakdown 3",
          column(
            width = 10,
            h6(
              "Loudest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$loudness,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                " - ",
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$loudness,
                      decreasing = TRUE
                      ),
                  ][1, ]$loudness,
                  3
                ),
                " db",
                sep = ""
              )
            ),
            br(),
            h6(
              "Quietest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$loudness),
                ][1, ]$name,
                " - ",
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$loudness),
                  ][1, ]$loudness,
                  3
                ),
                " db",
                sep = ""
              )
            ),
            br(),
            h6(
              "Fastest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$tempo,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                " - ",
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$tempo,
                      decreasing = TRUE
                      ),
                  ][1, ]$tempo
                ),
                " bpm",
                sep = ""
              )
            ),
            br(),
            h6(
              "Slowest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$tempo),
                ][1, ]$name,
                " - ",
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$tempo),
                  ][1, ]$tempo
                ),
                " bpm",
                sep = ""
              )
            ),
            br(),
            h6(
              "Happiest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(
                    album_infos$album_features$valence,
                    decreasing = TRUE
                    ),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(
                      album_infos$album_features$valence,
                      decreasing = TRUE
                      ),
                  ][1, ]$valence,
                  3
                ),
                sep = " - "
              )
            ),
            br(),
            h6(
              "Saddest album"
            ),
            p(
              paste(
                album_infos$album_features[
                  order(album_infos$album_features$valence),
                ][1, ]$name,
                round(
                  album_infos$album_features[
                    order(album_infos$album_features$valence),
                  ][1, ]$valence,
                  3
                ),
                sep = " - "
              )
            )
          ),
          column(
            width = 2
          )
        ),
        tabPanel(
          "Song Breakdown 1",
          h6(
            ifelse(
              nrow(song_infos$most_popular_songs) > 1,
              "Most popular songs",
              "Most popular song"
            )
          ),
          p(
            ifelse(
              nrow(song_infos$most_popular_songs) > 1,
              paste(
                paste(
                  song_infos$most_popular_songs$name,
                  collapse = ", "
                ),
                song_infos$most_popular_songs$popularity,
                sep = " - "
              ),
              paste(
                song_infos$most_popular_songs$name,
                song_infos$most_popular_songs$popularity,
                sep = " - "
              )
            )
          ),
          br(),
          h6(
            ifelse(
              nrow(song_infos$least_popular_songs) > 1,
              "Least popular songs",
              "Least popular song"
            )
          ),
          p(
            ifelse(
              nrow(song_infos$least_popular_songs) > 1,
              paste(
                paste(
                  song_infos$least_popular_songs$name,
                  collapse = ", "
                ),
                song_infos$least_popular_songs$popularity,
                sep = " - "
              ),
              paste(
                song_infos$least_popular_songs$name,
                song_infos$least_popular_songs$popularity,
                sep = " - "
              )
            )
          ),
          br(),
          h6(
            "Longest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$duration_ms,
                  decreasing = TRUE
                  ),
              ][
                1,
              ]$track_name,
              " - ",
              paste(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$duration_ms,
                    decreasing = TRUE
                    ),
                ][1, 12:13],
                collapse = ":"
              ),
              " minutes",
              sep = ""
            )
          ),
          br(),
          h6(
            "Shortest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$duration_ms),
              ][
                1,
              ]$track_name,
              " - ",
              paste(
                song_infos$audio_features[
                  order(song_infos$audio_features$duration_ms),
                ][1, 12:13],
                collapse = ":"
              ),
              " minutes",
              sep = ""
            )
          )
        ),
        tabPanel(
          "Song Breakdown 2",
          h6(
            "Most acoustic song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$acousticness,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$acousticness,
                    decreasing = TRUE
                    ),
                ][1, ]$acousticness,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Most instrumental song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$instrumentalness,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$instrumentalness,
                    decreasing = TRUE
                    ),
                ][1, ]$instrumentalness,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Most energetic song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$energy,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$energy,
                    decreasing = TRUE
                    ),
                ][1, ]$energy,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Least energetic song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$energy),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(song_infos$audio_features$energy),
                ][1, ]$energy,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Most danceable song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$danceability,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$danceability,
                    decreasing = TRUE
                    ),
                ][1, ]$danceability,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Least danceable song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$danceability),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(song_infos$audio_features$danceability),
                ][1, ]$danceability,
                3
              ),
              sep = " - "
            )
          )
        ),
        tabPanel(
          "Song Breakdown 3",
          h6(
            "Loudest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$loudness,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              " - ",
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$loudness,
                    decreasing = TRUE
                    ),
                ][1, ]$loudness,
                3
              ),
              " db",
              sep = ""
            )
          ),
          br(),
          h6(
            "Quietest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$loudness),
              ][1, ]$track_name,
              " - ",
              round(
                song_infos$audio_features[
                  order(song_infos$audio_features$loudness),
                ][1, ]$loudness,
                3
              ),
              " db",
              sep = ""
            )
          ),
          br(),
          h6(
            "Fastest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$tempo,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              " - ",
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$tempo,
                    decreasing = TRUE
                    ),
                ][1, ]$tempo
              ),
              " bpm",
              sep = ""
            )
          ),
          br(),
          h6(
            "Slowest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$tempo),
              ][1, ]$track_name,
              " - ",
              round(
                song_infos$audio_features[
                  order(song_infos$audio_features$tempo),
                ][1, ]$tempo
              ),
              " bpm",
              sep = ""
            )
          ),
          br(),
          h6(
            "Happiest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(
                  song_infos$audio_features$valence,
                  decreasing = TRUE
                  ),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(
                    song_infos$audio_features$valence,
                    decreasing = TRUE
                    ),
                ][1, ]$valence,
                3
              ),
              sep = " - "
            )
          ),
          br(),
          h6(
            "Saddest song"
          ),
          p(
            paste(
              song_infos$audio_features[
                order(song_infos$audio_features$valence),
              ][1, ]$track_name,
              round(
                song_infos$audio_features[
                  order(song_infos$audio_features$valence),
                ][1, ]$valence,
                3
              ),
              sep = " - "
            )
          )
        ),
        tabPanel(
          "Acoustic Analysis",
          br(),
          fluidRow(
            column(
              width = 4,
              pickerInput(
                "plot_var",
                choices = c(
                  "Acousticness",
                  "Danceability",
                  "Duration in seconds",
                  "Energy",
                  "Instrumentalness",
                  "Liveness",
                  "Loudness",
                  "Speechiness",
                  "Tempo",
                  "Valence"
                ),
                selected = "Acousticness",
                label = "Audio feature to display",
                options = list(
                  style = c("background: #242424;")
                )
              )
            ),
            column(
              width = 4,
              pickerInput(
                "plot_type",
                choices = c(
                  "Density",
                  "Histogram"
                ),
                selected = "Density",
                label = "Type of Plot",
                options = list(
                  style = c("background: #242424;")
                )
              )
            )
          ),
          fluidRow(
            column(
              width = 8,
              highchartOutput(
                "art1_plot",
                height = "60vh"
              )
            ),
            column(
              width = 4,
              htmlOutput(
                "explanation"
              )
            )
          )
        )
      )
    )
  )
}
