output$art1_plot <- renderHighchart({
  if(input$plot_type == "Density") {
    if (input$plot_var == "Duration in seconds") {
      dens <- density(song_infos$audio_features[, "duration_ms"] / 1000)
    } else {
      dens <- density(song_infos$audio_features[, tolower(input$plot_var)])
    }
    dens$y <- dens$y/sum(dens$y)
    highchart() %>%
      hc_chart(type = "area") %>%
      hc_add_theme(hc_theme_monokai()) %>%
      hc_xAxis(
        categories = round(dens$x, ifelse(any(dens$x) > 1, 1, 2)),
        gridLineWidth = 0,
        title = list(
          text = input$plot_var,
          style = list(
            color = "#fff",
            `font-size` = "calc(0.4em + 0.5vw)"
          )
        ),
        labels = list(
          style = list(
            color = "#fff",
            `font-size` = "calc(0.3em + 0.5vw)"
          )
        ),
        tickInterval = 20
      ) %>%
      hc_add_series(
        data = dens$y,
        color = "rgba(234, 95, 35, 1)",
        fillColor = "rgba(234, 95, 35, 0.1)"
      ) %>%
      hc_yAxis(
        title = list(
          text = "Density",
          style = list(
            color = "#fff",
            `font-size` = "calc(0.4em + 0.5vw)"
          )
        ),
        gridLineWidth = 1,
        gridLineColor = "rgba(255, 255, 255, 0.3)",
        gridLineDashStyle = "Solid",
        labels = list(
          style = list(
            color = "#fff",
            `font-size` = "calc(0.3em + 0.5vw)"
          )
        )
      ) %>%
      hc_chart(backgroundColor = "#242424") %>%
      hc_title(
        text = paste(
          input$plot_var,
          "of",
          art_infos$name,
          "songs"
        ),
        style = list(
          color = "#fff",
          `font-size` = "calc(1em + 0.5vw)"
        )
      ) %>%
      hc_legend(enabled = FALSE) %>%
      hc_tooltip(enabled = FALSE)
  } else {
    if(input$plot_var %in% c(
      "Acousticness", "Danceability", "Energy",
      "Instrumentalness", "Liveness", "Speechiness",
      "Valence"
    )) {
      hist <- hist(song_infos$audio_features[, tolower(input$plot_var)], plot = FALSE, breaks = seq(0, 1, 0.1))
      iv <- lapply(2:11, function(x, ...) {
        paste("(", hist$breaks[x - 1], ", ", hist$breaks[x], "]", sep = "")
      })
      
      highchart() %>%
        hc_chart(type = "column") %>%
        hc_add_theme(hc_theme_monokai()) %>%
        hc_xAxis(
          categories = iv,
          min = -0.01,
          gridLineWidth = 0,
          title = list(
            text = input$plot_var,
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_add_series(
          data = hist$counts,
          borderColor = "#EA5F23",
          color = "rgba(234, 95, 35, 0.2)",
          groupPadding = 0,
          pointPadding = 0,
          tooltip = list(
            pointFormat = paste(
              "Number of songs: {point.y}"
            ),
            headerFormat = "<span style='font-weight:bold'>{point.x}: </span><br>"
          )
        ) %>%
        hc_yAxis(
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_chart(backgroundColor = "#242424") %>%
        hc_title(
          text = paste(
            input$plot_var,
            "of",
            art_infos$name,
            "songs"
          ),
          style = list(
            color = "#fff",
            `font-size` = "calc(1em + 0.5vw)"
          )
        ) %>%
        hc_legend(enabled = FALSE)
    } else if(input$plot_var == "Loudness") {
      hist <- hist(song_infos$audio_features$loudness, plot = FALSE, breaks = seq(-60, 0, 2))
      iv <- seq(-60, 0, 10)
      iv <- lapply(2:31, function(x, ...) {
        paste("(", hist$breaks[x - 1], ", ", hist$breaks[x], "]", sep = "")
      })
      highchart() %>%
        hc_chart(type = "column") %>%
        hc_add_theme(hc_theme_monokai()) %>%
        hc_xAxis(
          categories = c(unlist(iv), ""),
          min = -0.01,
          gridLineWidth = 0,
          title = list(
            text = input$plot_var,
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          ),
          tickInterval = 5
        ) %>%
        hc_add_series(
          data = c(hist$counts, 0),
          borderColor = "#EA5F23",
          color = "rgba(234, 95, 35, 0.2)",
          groupPadding = 0,
          pointPadding = 0,
          tooltip = list(
            pointFormat = paste(
              "Number of songs: {point.y}"
            ),
            headerFormat = "<span style='font-weight:bold'>{point.x}: </span><br>"
          )
        ) %>%
        hc_yAxis(
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_chart(backgroundColor = "#242424") %>%
        hc_title(
          text = paste(
            input$plot_var,
            "of",
            art_infos$name,
            "songs"
          ),
          style = list(
            color = "#fff",
            `font-size` = "calc(1em + 0.5vw)"
          )
        ) %>%
        hc_legend(enabled = FALSE)
    } else if (input$plot_var == "Duration in seconds") {
      max <- round_any(max(song_infos$audio_features$duration_ms / 1000), 100)
      hist <- hist(
        song_infos$audio_features$duration_ms / 1000, plot = FALSE,
        breaks = seq(0, max, 100)
        )
      iv <- seq(0, max, 100)
      iv <- lapply(2:length(iv), function(x, ...) {
        paste("(", hist$breaks[x - 1], ", ", hist$breaks[x], "]", sep = "")
      })
      highchart() %>%
        hc_chart(type = "column") %>%
        hc_add_theme(hc_theme_monokai()) %>%
        hc_xAxis(
          categories = iv,
          min = -0.01,
          gridLineWidth = 0,
          title = list(
            text = input$plot_var,
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          ),
          tickInterval = 5
        ) %>%
        hc_add_series(
          data = hist$counts,
          borderColor = "#EA5F23",
          color = "rgba(234, 95, 35, 0.2)",
          groupPadding = 0,
          pointPadding = 0,
          tooltip = list(
            pointFormat = paste(
              "Number of songs: {point.y}"
            ),
            headerFormat = "<span style='font-weight:bold'>{point.x}: </span><br>"
          )
        ) %>%
        hc_yAxis(
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_chart(backgroundColor = "#242424") %>%
        hc_title(
          text = paste(
            input$plot_var,
            "of",
            art_infos$name,
            "songs"
          ),
          style = list(
            color = "#fff",
            `font-size` = "calc(1em + 0.5vw)"
          )
        ) %>%
        hc_legend(enabled = FALSE)
    } else {
      hist <- hist(song_infos$audio_features$tempo, plot = FALSE, breaks = seq(0, 250, 10))
      iv <- seq(0, 250, 10)
      iv <- lapply(2:26, function(x, ...) {
        paste("(", hist$breaks[x - 1], ", ", hist$breaks[x], "]", sep = "")
      })
      highchart() %>%
        hc_chart(type = "column") %>%
        hc_add_theme(hc_theme_monokai()) %>%
        hc_xAxis(
          categories = iv,
          min = -0.01,
          gridLineWidth = 0,
          title = list(
            text = input$plot_var,
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          ),
          tickInterval = 5
        ) %>%
        hc_add_series(
          data = hist$counts,
          borderColor = "#EA5F23",
          color = "rgba(234, 95, 35, 0.2)",
          groupPadding = 0,
          pointPadding = 0,
          tooltip = list(
            pointFormat = paste(
              "Number of songs: {point.y}"
            ),
            headerFormat = "<span style='font-weight:bold'>{point.x}: </span><br>"
          )
        ) %>%
        hc_yAxis(
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        hc_chart(backgroundColor = "#242424") %>%
        hc_title(
          text = paste(
            input$plot_var,
            "of",
            art_infos$name,
            "songs"
          ),
          style = list(
            color = "#fff",
            `font-size` = "calc(1em + 0.5vw)"
          )
        ) %>%
        hc_legend(enabled = FALSE)
    }
  }
})