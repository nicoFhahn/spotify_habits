output$art1_plot <- renderHighchart({
  # check for density plot
  if (input$plot_type == "Density") {
    # calculate the density of the duration in seconds
    if (input$plot_var == "Duration in seconds") {
      dens <- density(
        song_infos$values$audio_features[, "duration_ms"] / 1000,
        from = 0
      )
    } else if (input$plot_var %in% c(
      "Acousticness", "Danceability", "Energy",
      "Instrumentalness", "Liveness", "Speechiness",
      "Valence"
    )) {
      # calculate the density
      dens <- density(
        song_infos$values$audio_features[, tolower(input$plot_var)],
        from = -0.2,
        to = 1.2
      )
    } else if (input$plot_var == "Tempo") {
      # calculate the density for the tempo
      dens <- density(
        song_infos$values$audio_features[, tolower(input$plot_var)],
        from = 0,
        to = 250
      )
    } else {
      # calculate the density for loudness
      dens <- density(
        song_infos$values$audio_features[, tolower(input$plot_var)]
      )
    }
    # get the relative density
    dens$y <- dens$y / sum(dens$y)
    highchart() %>%
      # area chart
      hc_chart(type = "area") %>%
      # set the theme
      hc_add_theme(hc_theme_monokai()) %>%
      # add the x axis values
      hc_xAxis(
        # set the categories
        categories = round(dens$x, ifelse(any(dens$x) > 1, 1, 2)),
        # no gridLine
        gridLineWidth = 0,
        # set the title
        title = list(
          text = input$plot_var,
          # style the title
          style = list(
            color = "#fff",
            `font-size` = "calc(0.4em + 0.5vw)"
          )
        ),
        # style the labels
        labels = list(
          style = list(
            color = "#fff",
            `font-size` = "calc(0.3em + 0.5vw)"
          )
        ),
        # set the tick interval
        tickInterval = 20
      ) %>%
      # add the data for the density
      hc_add_series(
        data = dens$y,
        # style it
        color = "rgba(234, 95, 35, 1)",
        fillColor = "rgba(234, 95, 35, 0.1)",
        states = list(
          hover = list(
            enabled = FALSE
          )
        )
      ) %>%
      # style the y-axis
      hc_yAxis(
        # set the title
        title = list(
          text = "Density",
          # style it
          style = list(
            color = "#fff",
            `font-size` = "calc(0.4em + 0.5vw)"
          )
        ),
        # style the gridLine
        gridLineWidth = 1,
        gridLineColor = "rgba(255, 255, 255, 0.3)",
        gridLineDashStyle = "Solid",
        # style the labels
        labels = list(
          style = list(
            color = "#fff",
            `font-size` = "calc(0.3em + 0.5vw)"
          )
        )
      ) %>%
      # set the background color
      hc_chart(backgroundColor = "#242424") %>%
      # set the title
      hc_title(
        text = paste(
          input$plot_var,
          "of",
          art_infos$name,
          "songs"
        ),
        # style it
        style = list(
          color = "#fff",
          `font-size` = "calc(1em + 0.5vw)"
        )
      ) %>%
      # remove the legend
      hc_legend(enabled = FALSE) %>%
      # remove the tooltip
      hc_tooltip(enabled = FALSE)
  } else {
    # histogram for variables with values between 0 and 1
    if (input$plot_var %in% c(
      "Acousticness", "Danceability", "Energy",
      "Instrumentalness", "Liveness", "Speechiness",
      "Valence"
    )) {
      # get the histogram values
      hist <- hist(
        song_infos$values$audio_features[, tolower(input$plot_var)],
        plot = FALSE,
        # custom breaks
        breaks = seq(0, 1, 0.1)
      )
      # get the intervals for labelling
      iv <- lapply(2:11, function(x, ...) {
        paste("(", hist$breaks[x - 1], ", ", hist$breaks[x], "]", sep = "")
      })
      # plot it
      highchart() %>%
        # column chart
        hc_chart(type = "column") %>%
        # set the theme
        hc_add_theme(hc_theme_monokai()) %>%
        # set the xAxis
        hc_xAxis(
          # set the categories
          categories = iv,
          # minimum value
          min = -0.01,
          # no gridLine
          gridLineWidth = 0,
          # set the title
          title = list(
            text = input$plot_var,
            # style it
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          # style the labels
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        # add data for the histogram
        hc_add_series(
          data = hist$counts,
          # set the border color
          borderColor = "#EA5F23",
          # set the fillColor
          color = "rgba(234, 95, 35, 0.2)",
          # no group and point padding
          groupPadding = 0,
          pointPadding = 0,
          # edit the tooltip
          tooltip = list(
            pointFormat = paste(
              "Number of songs: {point.y}"
            ),
            headerFormat = "
            <span style='font-weight:bold'>{point.x}:</span><br>"
          )
        ) %>%
        # set the yAxis
        hc_yAxis(
          # set the title
          title = list(
            text = "Count",
            style = list(
              color = "#fff",
              `font-size` = "calc(0.4em + 0.5vw)"
            )
          ),
          # style the gridLine
          gridLineWidth = 1,
          gridLineColor = "rgba(255, 255, 255, 0.3)",
          gridLineDashStyle = "Solid",
          # style the labels
          labels = list(
            style = list(
              color = "#fff",
              `font-size` = "calc(0.3em + 0.5vw)"
            )
          )
        ) %>%
        # set the background color
        hc_chart(backgroundColor = "#242424") %>%
        # set the title
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
        # no legend
        hc_legend(enabled = FALSE)
      # histogram for loudness
    } else if (input$plot_var == "Loudness") {
      # all the same as the last histogram, check the comments there
      hist <- hist(
        song_infos$values$audio_features$loudness,
        plot = FALSE,
        breaks = seq(-60, 0, 2)
      )
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
            headerFormat = "
            <span style='font-weight:bold'>{point.x}: </span><br>
            "
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
      # histogram for duration
    } else if (input$plot_var == "Duration in seconds") {
      # all the same as the first histogram, check the comments there
      max <- round_any(
        max(song_infos$values$audio_features$duration_ms / 1000),
        100,
        ceiling
      )
      hist <- hist(
        song_infos$values$audio_features$duration_ms / 1000,
        plot = FALSE,
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
            headerFormat = "
            <span style='font-weight:bold'>{point.x}: </span><br>
            "
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
      # histogram for the tempo
    } else {
      # all the same as the first histogram, check the comments there
      hist <- hist(
        song_infos$values$audio_features$tempo,
        plot = FALSE,
        breaks = seq(0, 250, 10)
      )
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
            headerFormat = "
            <span style='font-weight:bold'>{point.x}: </span><br>
            "
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

output$track_plot_1 <- renderHighchart({
  data <- track_analysis$values$sections
  data$iv <- paste(
    "[",
    round(data$start),
    "; ",
    round(data$start + data$duration),
    ")",
    sep = ""
  )
  data$iv[nrow(data)] <- str_replace(data$iv[nrow(data)], "\\)", "]")
  highchart() %>%
    hc_chart(type = "line") %>%
    hc_add_theme(hc_theme_monokai()) %>%
    hc_xAxis(
      # set the categories
      categories = data$iv,
      # minimum value
      min = -0.01,
      # no gridLine
      gridLineWidth = 0,
      # set the title
      title = list(
        text = "Loudness and tempo",
        # style it
        style = list(
          color = "#fff",
          `font-size` = "calc(0.4em + 0.5vw)"
        )
      ),
      # style the labels
      labels = list(
        style = list(
          color = "#fff",
          `font-size` = "calc(0.3em + 0.5vw)"
        )
      )
    ) %>%
    hc_add_series(
      data$loudness,
      # set the border color
      borderColor = "#F19A3E",
      # set the fillColor
      color = "rgba(241, 154, 62, 1)",
      # edit the tooltip
      tooltip = list(
        pointFormat = paste(
          "Average loudness in db: {point.y}"
        ),
        headerFormat = "
            <span style='font-weight:bold'>{point.x}:</span><br>"
      ),
      states = list(
        hover = list(
          enabled = FALSE
        ),
        inactive = list(
          opacity = 1
        )
      ),
      name = "Loudness"
    ) %>%
    hc_add_series(
      data$tempo,
      # set the border color
      borderColor = "#ABEDC6",
      # set the fillColor
      color = "rgba(171, 237, 198, 1)",
      # edit the tooltip
      tooltip = list(
        pointFormat = paste(
          "Average tempo in bpm: {point.y}"
        ),
        headerFormat = "
            <span style='font-weight:bold'>{point.x}:</span><br>"
      ),
      states = list(
        hover = list(
          enabled = FALSE
        ),
        inactive = list(
          opacity = 1
        )
      ),
      name = "Tempo"
    ) %>% # set the yAxis
    hc_yAxis(
      # set the title
      title = list(
        text = "Value",
        style = list(
          color = "#fff",
          `font-size` = "calc(0.4em + 0.5vw)"
        )
      ),
      # style the gridLine
      gridLineWidth = 1,
      gridLineColor = "rgba(255, 255, 255, 0.3)",
      gridLineDashStyle = "Solid",
      # style the labels
      labels = list(
        style = list(
          color = "#fff",
          `font-size` = "calc(0.3em + 0.5vw)"
        )
      )
    ) %>%
    # set the background color
    hc_chart(backgroundColor = "#242424") %>%
    # set the title
    hc_title(
      text = paste(
        "Loudness and tempo of",
        track_infos$values$title
      ),
      style = list(
        color = "#fff",
        `font-size` = "calc(1em + 0.5vw)"
      )
    )
})

output$track_plot_2 <- renderHighchart({
  data <- track_analysis$values
  data_bars <- data$bars
  data_bars$id <- 1
  data_beats <- data$beats
  data_beats$id <- 2
  data_tatums <- data$tatums
  data_tatums$id <- 3
  data_sections <- data$sections
  plot_lines <- lapply(
    data_sections$start[2:nrow(data_sections)], function(x, ...) {
      list(
        label = list(
          text = paste(
            "End section",
            match(
              x,
              data_sections$start[2:nrow(data_sections)]
            )
          )
        ),
        color = "rgba(234, 95, 35, 0.9)",
        width = 1,
        value = x,
        zIndex = 10
      )
    }
  )
  highchart() %>%
    hc_add_theme(hc_theme_monokai()) %>%
    hc_add_series(
      data_bars,
      "scatter",
      color = "#FFC971",
      hcaes(
        x = start,
        y = id
      ),
      marker = list(
        radius = 3,
        symbol = "diamond"
      ),
      states = list(
        hover = list(
          enabled = FALSE
        ),
        inactive = list(
          opacity = 1
        )
      ),
      name = "Bars"
    ) %>%
    hc_add_series(
      data_beats,
      "scatter",
      color = "#59A96A",
      hcaes(
        x = start,
        y = id
      ),
      marker = list(
        radius = 3,
        symbol = "square"
      ),
      states = list(
        hover = list(
          enabled = FALSE
        ),
        inactive = list(
          opacity = 1
        )
      ),
      name = "Beats"
    ) %>%
    hc_add_series(
      data_tatums,
      "scatter",
      color = "#D16666",
      hcaes(
        x = start,
        y = id
      ),
      marker = list(
        radius = 3,
        symbol = "circle"
      ),
      states = list(
        hover = list(
          enabled = FALSE
        ),
        inactive = list(
          opacity = 1
        )
      ),
      name = "Tatums"
    ) %>% # set the yAxis
    hc_xAxis(
      # set the title
      title = list(
        text = "Second",
        style = list(
          color = "#fff",
          `font-size` = "calc(0.4em + 0.5vw)"
        )
      ),
      # max = round(max(data_tatums$start)/4),
      # style the gridLine
      gridLineWidth = 0,
      # style the labels
      labels = list(
        style = list(
          color = "#fff",
          `font-size` = "calc(0.3em + 0.5vw)"
        )
      ),
      plotLines = plot_lines
    ) %>% # set the yAxis
    hc_yAxis(
      # set the title
      title = list(
        text = "Type",
        style = list(
          color = "#fff",
          `font-size` = "calc(0.4em + 0.5vw)"
        )
      ),
      categories = list(
        "", "Bars", "Beats", "Tatums"
      ),
      # style the gridLine
      gridLineWidth = 0,
      # style the labels
      labels = list(
        style = list(
          color = "#fff",
          `font-size` = "calc(0.3em + 0.5vw)"
        )
      )
    ) %>%
    # remove the tooltip
    hc_tooltip(enabled = FALSE) %>%
    hc_chart(
      zoomType = "x",
      backgroundColor = "#242424"
    ) %>%
    # set the title
    hc_title(
      text = paste(
        "Audio Analysis of",
        track_infos$values$title
      ),
      style = list(
        color = "#fff",
        `font-size` = "calc(1em + 0.5vw)"
      )
    )
})
