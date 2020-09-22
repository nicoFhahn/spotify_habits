create_random_grid <- function(urls, type) {
  sample_numbers <- sample(1:28, size = 20)
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
  urls_old <- urls
  for (x in skeleton) {
    number <- as.numeric(str_extract(x, "[0-9]{1,2}"))
    if (number %in% sample_numbers) {
      cover <- sample(urls, 1)
      id_first <- paste("artist_", type, "_", sep = "")
      id <- paste(id_first, match(cover, urls_old), sep = "")
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
  paste(
    "<div class = 'grid-container'>",
    paste(unlist(skeleton_images), collapse = ""),
    "</div>"
    )
}
alltime_grid <- create_random_grid(urls_alltime, "at")
recent_grid <- create_random_grid(urls_recent, "rc")
fluidPage(
  # add_busy_spinner(
  #   spin = "semipolar",
  #   color = "#EA5F23",
  #   margins = c(40, 20),
  #   height = "5%",
  #   width = "5%"
  #   ),
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
      div(
        class = "banner",
        h1(
          "Your Spotify listening habits"
        ),
        tags$canvas(
          id = "waves"
        ),
        h2(
          "An Overview"
        ),
        h3(
          "Learn more about not only yourself but also the artists you listen to"
        )
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        First, let's have a look at the artists you've been listening to the
        most since you became a part of the Spotify community. These artists
        have been by your side, whether you feel happy or sad, and you will
        always enjoy hearing their voices. Enough talk, here are your 20
        <span class = 'accent'>all-time</span> favorite artists:
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content_header",
        HTML(
          "<h1> Your <span class = 'accent'>all-time</span> favorite artists</h1>"
        )
      ),
      HTML(alltime_grid),
      div(
        class = "content_footer",
        HTML(
          "<h4><span class = 'accent'>Click</span> on any of the artists to
          get a detailed look at their music.<h4>"
        )
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        Of course, your listening habits won't always remain the same. As you
        discover new music and artists, some of your <span class = 'accent'>
        all-time</span> favorite artists will have to make way for others.
        Who might they be?  Let's take a look at which artists you listened to
        the most over the last month. Here are your <span class = 'accent'>
        recent</span> favorite artists:
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content_header",
        HTML(
          "<h1> Your <span class = 'accent'>recent</span> favorite artists</h1>"
        )
      ),
      HTML(recent_grid),
      div(
        class = "content_footer",
        HTML(
          "<h4><span class = 'accent'>Click</span> on any of the artists to
          get a detailed look at their music.<h4>"
        )
      )
    ),
    tags$section()
  ),
  tags$script(
    src = "fullpage.js"
  ),
  tags$script(
    src = "animate.js"
  ),
  tags$script(
    src = "https://isuttell.github.io/sine-waves/javascripts/sine-waves.min.js"
  ),
  tags$script(
    src = "waves.js"
  )
)
