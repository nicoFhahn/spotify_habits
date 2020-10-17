output$explanation <- renderText({
  if (input$plot_var == "Acousticness") {
    expl <- '<span class="accent">Acousticness</span> is a confidence
      measure from 0.0 to 1.0 of whether the track is acoustic.
      1.0 represents high confidence the track is acoustic.'
  } else if (input$plot_var == "Danceability") {
    expl <- '<span class="accent">Danceability</span> describes how
      suitable a track is for dancing based on a combination of musical
      elements including tempo, rhythm stability, beat strength, and
      overall regularity. A value of 0.0 is least danceable
      and 1.0 is most danceable.'
  } else if (input$plot_var == "Energy") {
    expl <- '<span class="accent">Energy</span> is a measure from 0.0
      to 1.0 and represents a perceptual measure of intensity and activity.
      Typically, energetic tracks feel fast, loud, and noisy. For example,
      death metal has high energy, while a Bach prelude scores low on
      the scale. Perceptual features contributing to this attribute include
      dynamic range, perceived loudness, timbre, onset rate, and
      general entropy.'
  } else if (input$plot_var == "Instrumentalness") {
    expl <- '<span class="accent">Instrumentalness</span> predicts
      whether a track contains no vocals. "Ooh" and "aah" sounds are treated
      as instrumental in this context. Rap or spoken word tracks are clearly
      "vocal". The closer the instrumentalness value is to 1.0, the greater
      likelihood the track contains no vocal content. Values above 0.5 are
      intended to represent instrumental tracks, but confidence is higher as
      the value approaches 1.0.'
  } else if (input$plot_var == "Liveness") {
    expl <- '<span class="accent">Liveness</span> detects the presence of
      an audience in the recording. Higher liveness values represent an
      increased probability that the track was performed live. A value above
      0.8 provides strong likelihood that the track is live.'
  } else if (input$plot_var == "Loudness") {
    expl <- 'The overall <span class="accent">loudness</span> of a track
      in decibels (dB). Loudness values are averaged across the entire track
      and are useful for comparing relative loudness of tracks. Loudness is
      the quality of a sound that is the primary psychological correlate of
      physical strength (amplitude). Values typical range between -60 and 0 db.'
  } else if (input$plot_var == "Speechiness") {
    expl <- '<span class="accent">Speechiness</span> detects the presence
      of spoken words in a track. The more exclusively speech-like the
      recording (e.g. talk show, audio book, poetry), the closer to 1.0 the
      attribute value. Values above 0.66 describe tracks that are probably
      made entirely of spoken words. Values between 0.33 and 0.66 describe
      tracks that may contain both music and speech, either in sections or
      layered, including such cases as rap music. Values below 0.33 most
      likely represent music and other non-speech-like tracks.'
  } else if (input$plot_var == "Tempo") {
    expl <- 'The overall estimated <span class="accent">tempo</span> of a
      track in beats per minute (BPM). In musical terminology, tempo is the
      speed or pace of a given piece and derives directly from
      the average beat duration.'
  } else if (input$plot_var == "Valence") {
    expl <- '<span class="accent">Valence</span> is a measure from 0.0
      to 1.0 describing the musical positiveness conveyed by a track.
      Tracks with high valence sound more positive (e.g. happy, cheerful,
      euphoric), while tracks with low valence sound more negative
      (e.g. sad, depressed, angry).'
  } else {
    expl <- 'The <span class="accent">duration</span>
      of the track in seconds.'
  }
  HTML(paste("<br> <br>", expl))
})

output$explanation_song <- renderText({
  if (clicked$last == "Acousticness") {
    expl <- '<span class="accent">Acousticness</span> is a confidence
      measure from 0.0 to 1.0 of whether the track is acoustic.
      1.0 represents high confidence the track is acoustic.'
  } else if (clicked$last == "Danceability") {
    expl <- '<span class="accent">Danceability</span> describes how
      suitable a track is for dancing based on a combination of musical
      elements including tempo, rhythm stability, beat strength, and
      overall regularity. A value of 0.0 is least danceable
      and 1.0 is most danceable.'
  } else if (clicked$last == "Energy") {
    expl <- '<span class="accent">Energy</span> is a measure from 0.0
      to 1.0 and represents a perceptual measure of intensity and activity.
      Typically, energetic tracks feel fast, loud, and noisy. For example,
      death metal has high energy, while a Bach prelude scores low on
      the scale. Perceptual features contributing to this attribute include
      dynamic range, perceived loudness, timbre, onset rate, and
      general entropy.'
  } else if (clicked$last == "Instrumentalness") {
    expl <- '<span class="accent">Instrumentalness</span> predicts
      whether a track contains no vocals. "Ooh" and "aah" sounds are treated
      as instrumental in this context. Rap or spoken word tracks are clearly
      "vocal". The closer the instrumentalness value is to 1.0, the greater
      likelihood the track contains no vocal content. Values above 0.5 are
      intended to represent instrumental tracks, but confidence is higher as
      the value approaches 1.0.'
  } else if (clicked$last == "Liveness") {
    expl <- '<span class="accent">Liveness</span> detects the presence of
      an audience in the recording. Higher liveness values represent an
      increased probability that the track was performed live. A value above
      0.8 provides strong likelihood that the track is live.'
  } else if (clicked$last == "Loudness") {
    expl <- 'The overall <span class="accent">loudness</span> of a track
      in decibels (dB). Loudness values are averaged across the entire track
      and are useful for comparing relative loudness of tracks. Loudness is
      the quality of a sound that is the primary psychological correlate of
      physical strength (amplitude). Values typical range between -60 and 0 db.'
  } else if (clicked$last == "Speechiness") {
    expl <- '<span class="accent">Speechiness</span> detects the presence
      of spoken words in a track. The more exclusively speech-like the
      recording (e.g. talk show, audio book, poetry), the closer to 1.0 the
      attribute value. Values above 0.66 describe tracks that are probably
      made entirely of spoken words. Values between 0.33 and 0.66 describe
      tracks that may contain both music and speech, either in sections or
      layered, including such cases as rap music. Values below 0.33 most
      likely represent music and other non-speech-like tracks.'
  } else if (clicked$last == "Tempo") {
    expl <- 'The overall estimated <span class="accent">tempo</span> of a
      track in beats per minute (BPM). In musical terminology, tempo is the
      speed or pace of a given piece and derives directly from
      the average beat duration.'
  } else if (clicked$last == "Valence") {
    expl <- '<span class="accent">Valence</span> is a measure from 0.0
      to 1.0 describing the musical positiveness conveyed by a track.
      Tracks with high valence sound more positive (e.g. happy, cheerful,
      euphoric), while tracks with low valence sound more negative
      (e.g. sad, depressed, angry).'
  } else {
    expl <- 'The <span class="accent">duration</span>
      of the track in seconds.'
  }
  HTML(expl)
})

output$explanation_plot_1 <- renderText({
  HTML(
    'In this plot you can see how the average
    <span class="accent">loudness</span> and
    <span class="accent">tempo</span> of a given song evolves through
    the sections of the song.  <span class="accent">Sections</span>
    are defined by large variations in rhythm or timbre, e.g. chorus,
    verse, bridge, guitar solo, etc.'
  )
})

output$explanation_plot_2 <- renderText({
  HTML(
    'In this plot you can see the four different rhythm subdivision of the
    song. <br>
    <span class="accent">Sections</span>
    are defined by large variations in rhythm or timbre, e.g. chorus,
    verse, bridge, guitar solo, etc. <br>
    A <span class="accent">bar </span> is a segment of time defined as a given
    number of beats. Bar offsets also indicate downbeats,
    the first beat of the measure. <br>
    A <span class="accent">beat</span> is the basic time unit of a piece
    of music; for example, each tick of a metronome.
    Beats are typically multiples of tatums. <br>
    A <span class="accent">tatum</span> represents the lowest regular pulse
    train that a listener intuitively infers from the timing of perceived
    musical events (segments). <br>
    Beats are subdivisions of bars. Tatums are subdivisions of beats.
    That is, bars always align with a beat and ditto tatums. <br>
    You can use your mouse along the x-axis to zoom in on a smaller portion
    of the track.'
  )
})


output$clust_1_out <- renderText({
  if (clust_number$val[1]) {
    samples <- sample_songs$val[[1]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 1, ]$artists[[1]][samples],
          clustered[clustered$cluster == 1, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_2_out <- renderText({
  if (clust_number$val[2]) {
    samples <- sample_songs$val[[2]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 2, ]$artists[[1]][samples],
          clustered[clustered$cluster == 2, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_3_out <- renderText({
  if (clust_number$val[3]) {
    samples <- sample_songs$val[[3]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 3, ]$artists[[1]][samples],
          clustered[clustered$cluster == 3, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_4_out <- renderText({
  if (clust_number$val[4]) {
    samples <- sample_songs$val[[4]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 4, ]$artists[[1]][samples],
          clustered[clustered$cluster == 4, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_5_out <- renderText({
  if (clust_number$val[5]) {
    samples <- sample_songs$val[[5]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 5, ]$artists[[1]][samples],
          clustered[clustered$cluster == 5, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_6_out <- renderText({
  if (clust_number$val[6]) {
    samples <- sample_songs$val[[6]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 6, ]$artists[[1]][samples],
          clustered[clustered$cluster == 6, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_7_out <- renderText({
  if (clust_number$val[7]) {
    samples <- sample_songs$val[[7]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 7, ]$artists[[1]][samples],
          clustered[clustered$cluster == 7, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_8_out <- renderText({
  if (clust_number$val[8]) {
    samples <- sample_songs$val[[8]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 8, ]$artists[[1]][samples],
          clustered[clustered$cluster == 8, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})

output$clust_9_out <- renderText({
  if (clust_number$val[9]) {
    samples <- sample_songs$val[[9]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 9, ]$artists[[1]][samples],
          clustered[clustered$cluster == 9, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})


output$clust_10_out <- renderText({
  if (clust_number$val[10]) {
    samples <- sample_songs$val[[10]]
    HTML(
      paste(
        paste(
          clustered[clustered$cluster == 10, ]$artists[[1]][samples],
          clustered[clustered$cluster == 10, ]$tracks[[1]][samples],
          sep = " - "
        ),
        collapse = "<br>"
      )
    )
  } else {
    HTML("<br>")
  }
})
