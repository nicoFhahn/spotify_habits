output$alltime_grid_ui <- renderUI({
  if (clicks_1$n == 0) {
    clicks_1$n <- 1
    actionButton("at_grid_button", label = "Reveal artists")
  } else {
    HTML('<button id="at_grid_button" type="button" class="btn btn-default action-button">Reveal artists</button> <div id="alltime_grid_html" class="shiny-html-output"></div>')
  }
})

output$recent_grid_ui <- renderUI({
  if (clicks_2$n == 0) {
    clicks_2$n <- 1
    actionButton("rc_grid_button", label = "Reveal artists")
  } else {
    HTML('<button id="rc_grid_button" type="button" class="btn btn-default action-button">Reveal artists</button> <div id="recent_grid_html" class="shiny-html-output"></div>')
  }
})

clicks_1 <- reactiveValues(
  n = 0
)

clicks_2 <- reactiveValues(
  n = 0
)


output$alltime_grid_html <- renderText({
  HTML(create_random_grid(urls_alltime[1:20], "at"))
})

output$table_alltime_artist_ui <- renderUI({
  htmlOutput("table_alltime_artist_html")
})

output$table_alltime_artist_html <- renderText({
  HTML(table_alltime_artist)
})

output$recent_grid_html <- renderText({
  HTML(create_random_grid(urls_recent[1:20], "rc"))
})

output$table_recent_artist_ui <- renderUI({
  htmlOutput("table_recent_artist_html")
})

output$table_recent_artist_html <- renderText({
  HTML(table_recent_artist)
})

output$table_alltime_songs_ui <- renderUI({
  htmlOutput("table_alltime_songs_html")
})

output$table_alltime_songs_html <- renderText({
  HTML(table_alltime_songs)
})

output$table_recent_songs_ui <- renderUI({
  htmlOutput("table_recent_songs_html")
})

output$table_recent_songs_html <- renderText({
  HTML(table_recent_songs)
})

output$ui_playlist <- renderUI({
  div(
    div(
      class = "playlist_in",
      textInput(
        "playlist_name",
        "Name your playlist"
      ),
      actionButton(
        "playlist_create",
        label = "Create playlist"
      )
    ),
    div(
      class = "playlist_out",
      htmlOutput(
        "playlist_out"
      )
    )
  )
})

output$playlist_out <- renderText({
  HTML(playlist_uri$uri)
})