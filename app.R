library(dotenv)
library(shiny)
library(shinyjs)
library(spotifyr)
library(sass)
library(stringr)
longdiv <- function(...) {
  div(
    ...,
    class = "container",
    style = "height:100vh;"
  )
}
bigbreak <- function(n) {
  HTML(paste(rep("<br></br>", n), collapse = ""))
}
# runjs()
# jsCode <- "function loginWithSpotify() {
#     var client_id = '98894b216d4143f5b3f8104668d2fd11';
#     var redirect_uri = 'http://127.0.0.1:3138/';
#     var scopes = 'playlist-modify-public user-read-email user-top-read user-follow-modify';
# 
#     if (document.location.hostname == 'localhost') {
#         redirect_uri = 'http://localhost:8000/index.html';
#     }
# 
#     var url = 'https://accounts.spotify.com/authorize?client_id=' + client_id +
#         '&response_type=token' +
#         '&scope=' + encodeURIComponent(scopes) +
#         '&redirect_uri=' + encodeURIComponent(redirect_uri);
#     document.location = url;
# }
# loginWithSpotify();
# 
load_dot_env("spotify_client.env")
access_token <- get_spotify_access_token()
# code <- get_spotify_authorization_code()
# longterm_art <- get_my_top_artists_or_tracks(
#   type = "artists",
#   time_range = "long_term",
#   limit = 10,
#   authorization = code
# )
load("artist.RData")
css1 <- sass(sass_file("www/style.scss"))
css2 <- sass(sass_file("www/artist_card.scss"))
# Define UI for application that draws a histogram
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value

# Define server logic required to draw a histogram
server <- function(input, output) {
  modal_rv <- reactiveValues(click = 0)
  shinyjs::onclick(
    "again",
    modal_rv$click <- modal_rv$click + 1
  )
  
  observeEvent(modal_rv$click, {
    if (modal_rv$click > 0) {
      showModal(
        modalDialog(
          easyClose = TRUE,
          fluidRow(
            column(
              width = 6,
              tags$figure(
                id = "alltime_1",
                class = "artist_card card_bg_red",
                img(
                  src = image_1,
                  align = "center",
                  class = "artist_card__img"
                ),
                tags$figcaption(
                  class = "artist_card__text-block",
                  p(
                    class = "artist_card__text r-title news__title r-link animated-underline animated-underline_type1 news__link",
                    "ARTIST"
                  ),
                  h2(
                    class = "artist_card__heading",
                    longterm_art$name[1]
                  )
                )
              ),
              bigbreak(7),
              tags$table(
                style = "width:100%;color:rgb(255,255,255);",
                class = "artist_table",
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    p(
                      class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                      "GENRE"
                    )
                  ),
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    h1(
                      span(
                        class = "wrap-reveal1",
                        span(
                          class = "reveal1",
                          str_to_title(genre_1)
                        )
                      )
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    p(
                      class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                      "POPULARITY"
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    h1(
                      span(
                        class = "wrap-reveal2",
                        span(
                          class = "reveal2",
                          popularity_1
                        )
                      )
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    p(
                      class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                      "#SONGS ON SPOTIFY"
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    h1(
                      span(
                        class = "wrap-reveal3",
                        span(
                          class = "reveal3",
                          number_of_songs_1
                        )
                      )
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    p(
                      class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                      "#ALBUMS ON SPOTIFY"
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    h1(
                      span(
                        class = "wrap-reveal4",
                        span(
                          class = "reveal4",
                          number_of_albums_1
                        )
                      )
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    p(
                      class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                      "RELATED ARTISTS"
                    )
                  )
                ),
                tags$tr(
                  style = "height:5vh;",
                  tags$td(
                    h1(
                      span(
                        class = "wrap-reveal5",
                        span(
                          class = "reveal5",
                          paste(related_artists_1[1:5], collapse = ", ")
                        )
                      )
                    )
                  )
                )
              )
            ),
            column(
              width = 6,
              bigbreak(5),
              tabsetPanel(
                tabPanel(
                  "Album Breakdown 1",
                  br(id = "smallbreak"),
                  column(
                    width = 6,
                    tags$table(
                      style = "width:100%;color:rgb(255,255,255);",
                      class = "disco_table",
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          p(
                            class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                            "MOST POPULAR ALBUM"
                          )
                        ),
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          h1(
                            span(
                              class = "wrap-reveal1",
                              span(
                                class = "reveal1",
                                paste(most_popular_albums_1[1, 1], "-", most_popular_albums_1$popularity)
                              )
                            )
                          )
                        )
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          p(
                            class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                            "LEAST POPULAR ALBUM"
                          )
                        ),
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          h1(
                            span(
                              class = "wrap-reveal2",
                              span(
                                class = "reveal2",
                                paste(least_popular_albums_1[1, 1], "-", least_popular_albums_1$popularity)
                              )
                            )
                          )
                        )
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          p(
                            class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                            "LONGEST ALBUM"
                          )
                        ),
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          h1(
                            span(
                              class = "wrap-reveal3",
                              span(
                                class = "reveal3",
                                paste(
                                  album_lengths_1[order(album_lengths_1$length, decreasing = TRUE), ][1, ]$name,
                                  "-",
                                  paste(round(album_lengths_1[order(album_lengths_1$length, decreasing = TRUE), ][1, ]$length / 60000), "minutes")
                                )
                              )
                            )
                          )
                        )
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          p(
                            class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                            "SHORTEST ALBUM"
                          )
                        ),
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          h1(
                            span(
                              class = "wrap-reveal4",
                              span(
                                class = "reveal4",
                                paste(
                                  album_lengths_1[order(album_lengths_1$length), ][1, ]$name,
                                  "-",
                                  paste(round(album_lengths_1[order(album_lengths_1$length), ][1, ]$length / 60000), "minutes")
                                )
                              )
                            )
                          )
                        )
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          p(
                            class = "r-title news__title r-link animated-underline animated-underline_type1 news__link",
                            "NEWEST ALBUM"
                          )
                        ),
                      ),
                      tags$tr(
                        style = "height:5vh;",
                        tags$td(
                          h1(
                            span(
                              class = "wrap-reveal5",
                              span(
                                class = "reveal5",
                                paste(newest_album_1[1, ], collapse = " - ")
                              )
                            )
                          )
                        )
                      )
                    )
                  ),
                  column(
                    width = 6,
                    fluidRow(
                      tags$figure(
                        id = "album_1",
                        class = "album_card album_card_bg_red",
                        img(
                          src = most_popular_albums_1$images[[1]][1, 2],
                          align = "center",
                          class = "album_card__img"
                        ),
                        tags$figcaption(
                          class = "album_card__text-block",
                          h2(
                            class = "album_card__heading",
                            most_popular_albums_1$name
                          )
                        )
                      )
                    ),
                    bigbreak(1),
                    fluidRow(
                      tags$figure(
                        id = "album_2",
                        class = "album_card album_card_bg_red",
                        img(
                          src = least_popular_albums_1$images[[1]][1, 2],
                          align = "center",
                          class = "album_card__img"
                        ),
                        tags$figcaption(
                          class = "album_card__text-block",
                          h2(
                            class = "album_card__heading",
                            least_popular_albums_1$name
                          )
                        )
                      )
                    ),
                    br()
                  )
                ),
                tabPanel(
                  "Album Breakdown 2"
                ),
                tabPanel(
                  "Single Breakdown 1"
                ),
                tabPanel(
                  "Single Breakdown 2"
                )
              )
            )
          )
        )
      )
    }
  })
  # if (read.table("a.txt")[1, 1] == 1) {
  #   runjs(jsCode)
  # }
  # write.table(1, "a.txt")
  # onStop(function() write.table(0, "a.txt"))
  source(file.path("server", "alltime_artists.R"), local = TRUE)$value
}

# Run the application
shinyApp(ui = ui, server = server)
