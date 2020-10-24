tags$section(
  class = "content_page",
  div(
    class = "content_header",
    HTML(
      "<h1> Average acoustic features of your
          <span class = 'accent'>saved</span> tracks</h1>"
    )
  ),
  highchartOutput(
    "change_plot",
    width = "60%",
    height = "60%"
  )
)