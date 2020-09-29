# define the function that shows the modal
show_modal <- function(type, ...) {
  if (type == "artist") {
    if (art_infos$values$albums > 0) {
      showModal(
        modalDialog(
          title = HTML(
            paste(
              tags$figure(
                tags$div(
                  class = "column accent_img",
                  tags$image(
                    src = art_infos$values$image
                  )
                ),
                tags$figcaption(
                  h4(
                    paste("#", art_infos$values$place, ":", art_infos$values$name, sep = "")
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
                width = 8,
                h6(
                  "Genre"
                ),
                p(
                  art_infos$values$genre
                ),
                br(),
                h6(
                  "Populartiy"
                ),
                p(
                  art_infos$values$popularity
                ),
                br(),
                h6(
                  "#Followers"
                ),
                p(
                  format(
                    art_infos$values$followers,
                    big.interval = 3, big.mark = " "
                  )
                ),
                br(),
                h6(
                  "#Albums on Spotify"
                ),
                p(
                  art_infos$values$albums
                ),
                br(),
                h6(
                  "#Songs on Spotify"
                ),
                p(
                  art_infos$values$songs
                ),
                br(),
                h6(
                  "Related artists"
                ),
                p(
                  paste(
                    art_infos$values$related,
                    collapse = ", "
                  )
                )
              )
            ),
            tabPanel(
              "Album Breakdown 1",
              column(
                width = 8,
                h6(
                  ifelse(
                    nrow(album_infos$values$most_popular_albums) > 1,
                    "Most popular albums",
                    "Most popular album"
                  )
                ),
                p(
                  ifelse(
                    nrow(album_infos$values$most_popular_albums) > 1,
                    paste(
                      paste(
                        album_infos$values$most_popular_albums$name,
                        collapse = ", "
                      ),
                      album_infos$values$most_popular_albums$popularity,
                      sep = " - "
                    ),
                    paste(
                      album_infos$values$most_popular_albums$name,
                      album_infos$values$most_popular_albums$popularity,
                      sep = " - "
                    )
                  )
                ),
                br(),
                h6(
                  ifelse(
                    nrow(album_infos$values$least_popular_albums) > 1,
                    "Least popular albums",
                    "Least popular album"
                  )
                ),
                p(
                  ifelse(
                    nrow(album_infos$values$least_popular_albums) > 1,
                    paste(
                      paste(
                        album_infos$values$least_popular_albums$name,
                        collapse = ", "
                      ),
                      album_infos$values$least_popular_albums$popularity,
                      sep = " - "
                    ),
                    paste(
                      album_infos$values$least_popular_albums$name,
                      album_infos$values$least_popular_albums$popularity,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$length),
                    ][
                      nrow(album_infos$values$album_features),
                    ][, 11],
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$length),
                      ][
                        nrow(album_infos$values$album_features),
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$length),
                    ][
                      1,
                    ][, 11],
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$length),
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$release_date),
                    ][
                      nrow(album_infos$values$album_features),
                    ]$name,
                    " (",
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$release_date),
                    ][
                      nrow(album_infos$values$album_features),
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$release_date),
                    ][1, ]$name,
                    " (",
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$release_date),
                    ][1, ]$release_date,
                    ")",
                    sep = ""
                  )
                )
              ),
              column(
                width = 4,
                HTML(album_infos$values$most_popular_albums$uri[1])
              )
            ),
            tabPanel(
              "Album Breakdown 2",
              column(
                width = 8,
                h6(
                  "Most acoustic album"
                ),
                p(
                  paste(
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$acousticness,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$acousticness,
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
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$instrumentalness,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$instrumentalness,
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
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$energy,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$energy,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$energy),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$energy),
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
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$danceability,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$danceability,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$danceability),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$danceability),
                      ][1, ]$danceability,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(album_infos$values$uri_2)
              )
            ),
            tabPanel(
              "Album Breakdown 3",
              column(
                width = 8,
                h6(
                  "Loudest album"
                ),
                p(
                  paste(
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$loudness,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$loudness,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$loudness),
                    ][1, ]$name,
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$loudness),
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
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$tempo,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$tempo,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$tempo),
                    ][1, ]$name,
                    " - ",
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$tempo),
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
                    album_infos$values$album_features[
                      order(
                        album_infos$values$album_features$valence,
                        decreasing = TRUE
                      ),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(
                          album_infos$values$album_features$valence,
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
                    album_infos$values$album_features[
                      order(album_infos$values$album_features$valence),
                    ][1, ]$name,
                    round(
                      album_infos$values$album_features[
                        order(album_infos$values$album_features$valence),
                      ][1, ]$valence,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(album_infos$values$uri_3)
              )
            ),
            tabPanel(
              "Song Breakdown 1",
              column(
                width = 8,
                h6(
                  ifelse(
                    nrow(song_infos$values$most_popular_songs) > 1,
                    "Most popular songs",
                    "Most popular song"
                  )
                ),
                p(
                  ifelse(
                    nrow(song_infos$values$most_popular_songs) > 1,
                    paste(
                      paste(
                        song_infos$values$most_popular_songs$name,
                        collapse = ", "
                      ),
                      song_infos$values$most_popular_songs$popularity,
                      sep = " - "
                    ),
                    paste(
                      song_infos$values$most_popular_songs$name,
                      song_infos$values$most_popular_songs$popularity,
                      sep = " - "
                    )
                  )
                ),
                br(),
                h6(
                  ifelse(
                    nrow(song_infos$values$least_popular_songs) > 1,
                    "Least popular songs",
                    "Least popular song"
                  )
                ),
                p(
                  ifelse(
                    nrow(song_infos$values$least_popular_songs) > 1,
                    paste(
                      paste(
                        song_infos$values$least_popular_songs$name,
                        collapse = ", "
                      ),
                      song_infos$values$least_popular_songs$popularity,
                      sep = " - "
                    ),
                    paste(
                      song_infos$values$least_popular_songs$name,
                      song_infos$values$least_popular_songs$popularity,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$duration_ms,
                        decreasing = TRUE
                      ),
                    ][
                      1,
                    ]$track_name,
                    " - ",
                    paste(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$duration_ms,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$duration_ms),
                    ][
                      1,
                    ]$track_name,
                    " - ",
                    paste(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$duration_ms),
                      ][1, 12:13],
                      collapse = ":"
                    ),
                    " minutes",
                    sep = ""
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$most_popular_songs$uri[1])
              )
            ),
            tabPanel(
              "Song Breakdown 2",
              column(
                width = 8,
                h6(
                  "Most acoustic song"
                ),
                p(
                  paste(
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$acousticness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$acousticness,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$instrumentalness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$instrumentalness,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$energy,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$energy,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$energy),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$energy),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$danceability,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$danceability,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$danceability),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$danceability),
                      ][1, ]$danceability,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$iframe_2)
              )
            ),
            tabPanel(
              "Song Breakdown 3",
              column(
                width = 8,
                h6(
                  "Loudest song"
                ),
                p(
                  paste(
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$loudness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$loudness,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$loudness),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$loudness),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$tempo,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$tempo,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$tempo),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$tempo),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$valence,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$valence,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$valence),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$valence),
                      ][1, ]$valence,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$iframe_3)
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
    } else {
      showModal(
        modalDialog(
          title = HTML(
            paste(
              tags$figure(
                tags$div(
                  class = "column accent_img",
                  tags$image(
                    src = art_infos$values$image
                  )
                ),
                tags$figcaption(
                  h4(
                    paste("#", art_infos$values$place, ":", art_infos$values$name, sep = "")
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
                width = 8,
                h6(
                  "Genre"
                ),
                p(
                  art_infos$values$genre
                ),
                br(),
                h6(
                  "Populartiy"
                ),
                p(
                  art_infos$values$popularity
                ),
                br(),
                h6(
                  "#Followers"
                ),
                p(
                  format(
                    art_infos$values$followers,
                    big.interval = 3, big.mark = " "
                  )
                ),
                br(),
                h6(
                  "#Albums on Spotify"
                ),
                p(
                  art_infos$values$albums
                ),
                br(),
                h6(
                  "#Songs on Spotify"
                ),
                p(
                  art_infos$values$songs
                ),
                br(),
                h6(
                  "Related artists"
                ),
                p(
                  paste(
                    art_infos$values$related,
                    collapse = ", "
                  )
                )
              )
            ),
            tabPanel(
              "Song Breakdown 1",
              column(
                width = 8,
                h6(
                  ifelse(
                    nrow(song_infos$values$most_popular_songs) > 1,
                    "Most popular songs",
                    "Most popular song"
                  )
                ),
                p(
                  ifelse(
                    nrow(song_infos$values$most_popular_songs) > 1,
                    paste(
                      paste(
                        song_infos$values$most_popular_songs$name,
                        collapse = ", "
                      ),
                      song_infos$values$most_popular_songs$popularity,
                      sep = " - "
                    ),
                    paste(
                      song_infos$values$most_popular_songs$name,
                      song_infos$values$most_popular_songs$popularity,
                      sep = " - "
                    )
                  )
                ),
                br(),
                h6(
                  ifelse(
                    nrow(song_infos$values$least_popular_songs) > 1,
                    "Least popular songs",
                    "Least popular song"
                  )
                ),
                p(
                  ifelse(
                    nrow(song_infos$values$least_popular_songs) > 1,
                    paste(
                      paste(
                        song_infos$values$least_popular_songs$name,
                        collapse = ", "
                      ),
                      song_infos$values$least_popular_songs$popularity,
                      sep = " - "
                    ),
                    paste(
                      song_infos$values$least_popular_songs$name,
                      song_infos$values$least_popular_songs$popularity,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$duration_ms,
                        decreasing = TRUE
                      ),
                    ][
                      1,
                    ]$track_name,
                    " - ",
                    paste(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$duration_ms,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$duration_ms),
                    ][
                      1,
                    ]$track_name,
                    " - ",
                    paste(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$duration_ms),
                      ][1, 12:13],
                      collapse = ":"
                    ),
                    " minutes",
                    sep = ""
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$most_popular_songs$uri[1])
              )
            ),
            tabPanel(
              "Song Breakdown 2",
              column(
                width = 8,
                h6(
                  "Most acoustic song"
                ),
                p(
                  paste(
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$acousticness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$acousticness,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$instrumentalness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$instrumentalness,
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$energy,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$energy,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$energy),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$energy),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$danceability,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$danceability,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$danceability),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$danceability),
                      ][1, ]$danceability,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$iframe_2)
              )
            ),
            tabPanel(
              "Song Breakdown 3",
              column(
                width = 8,
                h6(
                  "Loudest song"
                ),
                p(
                  paste(
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$loudness,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$loudness,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$loudness),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$loudness),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$tempo,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$tempo,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$tempo),
                    ][1, ]$track_name,
                    " - ",
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$tempo),
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
                    song_infos$values$audio_features[
                      order(
                        song_infos$values$audio_features$valence,
                        decreasing = TRUE
                      ),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(
                          song_infos$values$audio_features$valence,
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
                    song_infos$values$audio_features[
                      order(song_infos$values$audio_features$valence),
                    ][1, ]$track_name,
                    round(
                      song_infos$values$audio_features[
                        order(song_infos$values$audio_features$valence),
                      ][1, ]$valence,
                      3
                    ),
                    sep = " - "
                  )
                )
              ),
              column(
                width = 4,
                HTML(song_infos$values$iframe_3)
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
  } else {
    showModal(
      modalDialog(
        title = HTML(
          paste(
            tags$figure(
              tags$div(
                class = "column accent_img",
                tags$image(
                  src = track_infos$values$image
                )
              ),
              tags$figcaption(
                h4(
                  paste("#", track_infos$values$place, ":", track_infos$values$title, sep = ""),
                  class = "song_title"
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
              width = 8,
              h6(
                ifelse(
                  length(track_infos$values$artists) > 1,
                  "Artists",
                  "Artist"
                )
              ),
              p(
                paste(track_infos$values$artists, collapse = ", ")
              ),
              br(),
              h6(
                "Album"
              ),
              p(
                track_infos$values$album
              ),
              br(),
              h6(
                "Popularity"
              ),
              p(
                track_infos$values$popularity
              ),
              br(),
              h6(
                "Explicit"
              ),
              p(
                ifelse(
                  track_infos$values$explicit,
                  "Yes",
                  "No"
                )
              ),
              br(),
              h6(
                "Length"
              ),
              p(
                paste(
                  track_infos$values$minutes,
                  ":",
                  track_infos$values$seconds,
                  " minutes",
                  sep = ""
                )
              ),
            ),
            column(
              width = 4,
              HTML(track_infos$values$uri)
            )
          ),
          tabPanel(
            title = "Audio Features",
            column(
              width = 4,
              h6(
                id = "acoust",
                "Acousticness"
              ),
              p(
                track_details$values$acousticness
              ),
              br(),
              h6(
                id = "dance",
                "Danceability"
              ),
              p(
                track_details$values$danceability
              ),
              br(),
              h6(
                id = "energy",
                "Energy"
              ),
              p(
                track_details$values$energy
              ),
              br(),
              h6(
                id = "instrument",
                "Instrumentalness"
              ),
              p(
                track_details$values$instrumentalness 
              ),
              br(),
              h6(
                id = "live",
                "Liveness"
              ),
              p(
                track_details$values$liveness
              ),
              br(),
              br(),
              p(
                "Click on any of the feature names for an explanation of what
              exactly it is."
              )
            ),
            column(
              width = 4,
              h6(
                id = "loud",
                "Loudness"
              ),
              p(
                paste(track_details$values$loudness, "db")
              ),
              br(),
              h6(
                id = "speech",
                "Speechiness"
              ),
              p(
                track_details$values$speechiness
              ),
              br(),
              h6(
                id = "tempo",
                "Tempo"
              ),
              p(
                paste(track_details$values$tempo, "bpm")
              ),
              br(),
              h6(
                id = "valence",
                "Valence"
              ),
              p(
                track_details$values$valence 
              ),
            ),
            column(
              width = 4,
              h6(
                "Explanation"
              ),
              htmlOutput(
                "explanation_song"
              )
            )
          ),
          tabPanel(
            title = "Acoustic Analysis 1",
            column(
              width = 8,
              br(),
              highchartOutput(
                "track_plot_1",
                height = "60vh"
              )
            ),
            column(
              width = 4,
              br(),
              htmlOutput(
                "explanation_plot_1"
              )
            )
          ),
          tabPanel(
            title = "Acoustic Analysis 2",
            column(
              width = 8,
              br(),
              highchartOutput(
                "track_plot_2",
                height = "60vh"
              )
            ),
            column(
              width = 4,
              br(),
              htmlOutput(
                "explanation_plot_2"
              )
            )
          ),
          tabPanel(
            title = "You might also like",
            fluidRow(
              br(),
              p(
                id = "also",
                paste(
                  "Here are a few songs that you might also like, based
                on having similar features to ",
                  track_infos$values$title,
                  ".",
                  sep = ""
                )
              )
            ),
            fluidRow(
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_1)
              ),
              column(
                width = 1
              ),
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_2)
              ),
              column(
                width = 1
              ),
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_3)
              ),
              column(
                width = 1
              )
            ),
            fluidRow(
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_4)
              ),
              column(
                width = 1
              ),
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_5)
              ),
              column(
                width = 1
              ),
              column(
                class = "song_uri",
                width = 3,
                HTML(uri_sim$values$uri_6)
              ),
              column(
                width = 1
              )
            )
          )
        )
      )
    )
  }
}
