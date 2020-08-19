create_random_grid <- function(urls) {
  sample_days <- sample(1:28, size = 15)
  skeleton <- c(
    '<div class="area1"></div>',
    '<div class="area2"></div>',
    '<div class="area3"></div>',
    '<div class="area4"></div>',
    '<div class="area5"></div>',
    '<div class="area6"></div>',
    '<div class="area7"></div>',
    '<div class="area8"></div>',
    '<div class="area9"></div>',
    '<div class="area10"></div>',
    '<div class="area11"></div>',
    '<div class="area12"></div>',
    '<div class="area13"></div>',
    '<div class="area14"></div>',
    '<div class="area15"></div>',
    '<div class="area16"></div>',
    '<div class="area18"></div>',
    '<div class="area17"></div>',
    '<div class="area19"></div>',
    '<div class="area20"></div>',
    '<div class="area21"></div>',
    '<div class="area22"></div>',
    '<div class="area23"></div>',
    '<div class="area24"></div>',
    '<div class="area25"></div>',
    '<div class="area26"></div>',
    '<div class="area27"></div>',
    '<div class="area28"></div>'
  )
  skeleton_images <- c()
  for(x in skeleton) {
    number <- as.numeric(str_extract(x, "[0-9]{1,2}"))
    if (number %in% sample_days) {
      cover <- sample(urls, 1)
      urls <- urls[!urls %in% cover]
      skeleton_images <- c(
        skeleton_images,
        str_replace(
          x,
          "><",
          paste(
            "><img src = '",
            cover,
            "'><",
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
  paste("<div class = 'grid-container'>", paste(unlist(skeleton_images), collapse = ""), "</div>")
}
a <- create_random_grid(urls)
fullPage(
  useShinyjs(),
  tags$head(
    tags$style(
      css
    ),
    tags$link(rel = "stylesheet", href = "www/style.css")
    # tags$script(src = "js.js")
  ),
  includeCSS("www/style.css"),
  includeScript("www/js.js"),
  fullSection(
    class = "landing_page",
    center = TRUE,
    h1(
      "Your Spotify listening habits"
    ),
    h2(
      "An Overview"
    )
  ),
  fullSection(
    class = "content_page",
    fullSlide(
      fullColumn(
        width = 1
      ),
      fullColumn(
        width = 10,
        fullRow(
          HTML("<h1> Your <span class = 'accent'>alltime</span> favorite artists")
        ),
        fullRow(
          HTML(
            a
          )
        )
      ),
      fullColumn(
        width = 1
      ),
      center = TRUE
    ),
    fullSlide(
      style = "background-color: #242424;",
      fullColumn(
        width = 1
      ), 
      fullColumn(
        width = 10,
        fullRow(
          HTML(
            paste(
              "<h1> <span class = 'accent'>#1</span>",
              longterm_art$name[1],
              "</h1>"
            )
          ),
          h2(genre_1),
          h3(paste("Populartiy:", popularity_1)),
          h3(paste("Number of Albums:", number_of_albums_1)),
          h3(paste("Most popular Album:", most_popular_albums_1$name, "-", most_popular_albums_1$popularity)),
          h3(ifelse(
            nrow(least_popular_songs_1) <= 1,
            paste("Least popular Album:", least_popular_albums_1$name, "-", least_popular_albums_1$popularity),
            paste("Least popular Albums:", paste(least_popular_albums_1$name, collapse = "; "), "-", least_popular_albums_1$popularity[1])
          )),
          h3(paste("Number of Songs:", number_of_songs_1)),
          h3(paste("Most popular Song:", most_popular_songs_1$name, "-", most_popular_songs_1$popularity)),
          h3(ifelse(
            nrow(least_popular_songs_1) <= 1,
            paste("Least popular Song:", least_popular_songs_1$name, "-", least_popular_songs_1$popularity),
            paste("Least popular Songs:", paste(least_popular_songs_1$name, collapse = "; "), "-", least_popular_songs_1$popularity[1])
          )),
          h3(paste("Related Artists:", paste(related_artists_1[1:5], collapse = ", ")))
        )
      ),
      center = FALSE
    ),
    fullSlide(
      style = "background-color: #121212;",
      plotOutput("at_1_1")
    )
  ),
  fullSection(
    class = "content_page",
    fullSlide(
      class = "artist_page",
      fullColumn(
        width = 1
      ),
      fullColumn(
        width = 10,
        h1(longterm_art$name[1])
      ),
      fullColumn(
        width = 1
      )
    ),
    fullSlidePlot(
      "at_1_1",
      class = "artist_page",
      style = "background-color: #121212;"
    ),
    center = TRUE
  ),
  fullSectionPlot(
    "at_1_2"
  )
)
  
#   tags$header(
#     class = "show",
#     div(
#       class = "container",
#       fluidRow(
#         column(
#           width = 2
#         ),
#         column(
#           width = 8,
#           h1(
#             "Your Spotify listening habits"
#           ),
#           h2(
#             "An overview"
#           )
#         ),
#         column(
#           width = 2
#         )
#       )
#     )
#   ),
#   HTML('<section>
#     <div class="container">
#         <h1>Section 1</h1>
#         <h2>is all about steaks</h2>
#     </div>
# </section>'),
#   tags$section(
#     div(
#       class = "container",
#       fluidRow(
#         column(
#           width = 1
#         ),
#         column(
#           width = 10,
#           HTML(
#             "<h1> Your <span class = 'accent'>alltime</span>favorite artists<h1>" 
#           )
#         ),
#         column(
#           width = 1
#         )
#       )
#     )
#   ),
#   HTML('<footer>
#     <div class="container">
#         <h1>Footer</h1>
#     </div>
# </footer>')