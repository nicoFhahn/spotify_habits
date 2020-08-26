create_random_grid <- function(urls) {
  sample_days <- sample(1:28, size = 15)
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
  for (x in skeleton) {
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
            '><img class = "hidden" id = "',
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
    ),
    includeCSS(
      "www/styles.css"
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
        id = "click",
        "An Overview"
      )
    ),
    tags$section(
      class = "content_page",
      HTML("<h1> Your <span class = 'accent'>alltime</span> favorite artists</h1>"),
      HTML(a),
    ),
    tags$section(),
    tags$section(),
    tags$section()
  ),
  tags$script(
    src = "script.js"
  ),
  tags$script(
    src = "animate.js"
  )
)
