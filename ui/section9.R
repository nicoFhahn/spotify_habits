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
      uiOutput("table_alltime_songs_ui")
    ), #
    div(
      class = "content_footer",
      br(),
      HTML(
        "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
      )
    )
  ),
  HTML(
    "<h5 class = 'github'><a  target = '_blank' href='https://github.com/nicoFhahn/spotify_habits'>GitHub</a><h6>"
  )
)