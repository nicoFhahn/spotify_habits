create_random_grid <- function(urls) {
  sample_days <- sample(1:28, size = 15)
  skeleton <- c(
    '<div class="area1 hidden"></div>',
    '<div class="area2 hidden"></div>',
    '<div class="area3 hidden"></div>',
    '<div class="area4 hidden"></div>',
    '<div class="area5 hidden"></div>',
    '<div class="area6 hidden"></div>',
    '<div class="area7 hidden"></div>',
    '<div class="area8 hidden"></div>',
    '<div class="area9 hidden"></div>',
    '<div class="area10 hidden"></div>',
    '<div class="area11 hidden"></div>',
    '<div class="area12 hidden"></div>',
    '<div class="area13 hidden"></div>',
    '<div class="area14 hidden"></div>',
    '<div class="area15 hidden"></div>',
    '<div class="area16 hidden"></div>',
    '<div class="area17 hidden"></div>',
    '<div class="area18 hidden"></div>',
    '<div class="area19 hidden"></div>',
    '<div class="area20 hidden"></div>',
    '<div class="area21 hidden"></div>',
    '<div class="area22 hidden"></div>',
    '<div class="area23 hidden"></div>',
    '<div class="area24 hidden"></div>',
    '<div class="area25 hidden"></div>',
    '<div class="area26 hidden"></div>',
    '<div class="area27 hidden"></div>',
    '<div class="area28 hidden"></div>'
  )
  skeleton_images <- c()
  for(x in skeleton) {
    number <- as.numeric(str_extract(x, "[0-9]{1,2}"))
    if (number %in% sample_days) {
      cover <- sample(urls, 1)
      id <- paste("artist_at_", names(cover), sep = "")
      urls <- urls[!urls %in% cover]
      skeleton_images <- c(
        skeleton_images,
        str_replace(
          x,
          "><",
          paste(
            '><img id = "',
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
  paste("<div class = 'grid-container'>", paste(unlist(skeleton_images), collapse = ""), "</div>")
}
a <- create_random_grid(urls)
fluidPage(
  tags$head(
    tags$style(
      css
    )
  ),
  useShinyjs(),
  div(
    id = "fullpage",
    tags$section(
      class = "landing_page",
      h1(
        "Your Spotify listening habits"
      ),
      h2(
        "An Overview"
      )
    ),
    tags$section(
      class = "content_page",
      HTML("<h1> Your <span class = 'accent'>alltime</span> favorite artists</h1>"),
      HTML(a),
    ),
    tags$section(
      
    ),
    tags$section(
      
    ),
    tags$section(
      
    )
  ),
  tags$script(
    src = "script.js"
  ),
  tags$script(
    src = "animate.js"
  )
)