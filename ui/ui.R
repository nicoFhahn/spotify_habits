source(file.path("server", "create_html_thingys.R"), local = TRUE)$value
fluidPage(
  add_busy_spinner(
    spin = "semipolar",
    color = "#EA5F23",
    margins = c(40, 20),
    height = "5%",
    width = "5%"
  ),
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
        HTML(
          "<h1>Your spotify<br>listening<br>habits</h1>"
        ),
        tags$canvas(
          id = "waves"
        ),
        h2(
          "An Overview"
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
      id = "alltime",
      div(
        class = "content_header",
        HTML(
          "<h1>Your <span class = 'accent'>all-time</span> favorite
          artists</h1>"
        )
      ),
      HTML(alltime_grid),
      div(
        class = "content_footer",
        HTML(
          "<h4><span class = 'accent'>Click
          </span> on any of the artists to get a detailed look at their music.
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          Scroll down for the ranked view</h4>"
        )
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content_header",
        HTML(
          "<h1>Your <span class = 'accent'>all-time</span> favorite
          artists</h1>"
        )
      ),
      div(
        class = "content_table",
        HTML(table_alltime_artist)
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
          "<h4><span class = 'accent'>Click
          </span> on any of the artists to get a detailed look at their music.
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          Scroll down for the ranked view</h4>"
        )
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
      div(
        class = "content_table",
        HTML(table_recent_artist)
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        After taking a look at the artists you are listening to, we
        will now focus on the songs you listen to regularly. We'll once again
        be looking at your<span class='accent'>all-time</span> favorite
        songs and your most <span class='accent'>recent</span> favorites,
        starting with the first of the two:
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content",
        div(
          class = "content_header",
          HTML(
            "<h1>Your <span class = 'accent'>all-time</span> favorite
            songs</h1>"
          )
        ),
        div(
          class = "content_table",
          HTML(table_alltime_songs)
        ),
        div(
          class = "content_footer",
          br(),
          br(),
          HTML(
            "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
          )
        )
      ),
      div(
        class = "modal",
        h1("This is a modal page")
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        And now for the songs that you just can't get enough of in recent
        times. Here are your <span class='accent'>recent</span> favorite songs:
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content",
        div(
          class = "content_header",
          HTML(
            "<h1> Your <span class = 'accent'>recent</span> favorite songs</h1>"
          )
        ),
        div(
          class = "content_table",
          HTML(table_recent_songs)
        ),
        div(
          class = "content_footer",
          br(),
          br(),
          HTML(
            "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
          )
        )
      ),
      div(
        class = "modal",
        h1("This is a modal page")
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
