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
      uiOutput("table_recent_songs_ui")
    ),
    div(
      class = "content_footer",
      br(),
      HTML(
        "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
      )
    )
  )
)