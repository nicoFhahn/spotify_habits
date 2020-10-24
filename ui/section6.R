tags$section(
  class = "content_page",
  div(
    class = "content_header",
    HTML(
      "<h1> Your <span class = 'accent'>recent</span> favorite artists</h1>"
    )
  ),
  uiOutput("recent_grid_ui"),
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
)