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
    uiOutput("table_recent_artist_ui")
  ),
  HTML(
    "<h5 class = 'github'><a  target = '_blank' href='https://github.com/nicoFhahn/spotify_habits'>GitHub</a><h6>"
  )
)