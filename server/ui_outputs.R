output$alltime_grid_ui <- renderUI({
  htmlOutput("alltime_grid_html")
})

output$alltime_grid_html <- renderText({
  HTML(alltime_grid)
})

output$table_alltime_artist_ui <- renderUI({
  htmlOutput("table_alltime_artist_html")
})

output$table_alltime_artist_html <- renderText({
  HTML(table_alltime_artist)
})

output$recent_grid_ui <- renderUI({
  htmlOutput("recent_grid_html")
})

output$recent_grid_html <- renderText({
  HTML(recent_grid)
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
