fluidPage(
  add_busy_spinner(
    spin = "semipolar",
    color = "#EA5F23",
    margins = c(40, 20),
    height = "5%",
    width = "5%"
  ),
  tags$head(
    tags$style(
      css
    ),
    HTML(
      '<link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />'
    )
  ),
  useShinyjs(),
  div(
    id = "fullpage",
    tags$section(
      class = "landing_page",
      div(
        class = "banner",
        HTML(
          "<h1>Your spotify<br>listening<br>habits</h1>"
        ),
        tags$canvas(
          id = "waves"
        ),
        h2(
          "An Overview"
        ),
        HTML(
          "<h6>Because I am
          <sup>(or rather the spotifyr package is)</sup> kinda
          dumb you can only view my listening habits at the moment"
        )
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        First, let's have a look at the artists you've been listening to the
        most since you became a part of the Spotify community. These artists
        have been by your side, whether you feel happy or sad, and you will
        always enjoy hearing their voices. Enough talk, here are your 20
        <span class = 'accent'>all-time</span> favorite artists:
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      id = "alltime",
      div(
        class = "content_header",
        HTML(
          "<h1>Your <span class = 'accent'>all-time</span> favorite
          artists</h1>"
        )
      ),
      uiOutput("alltime_grid_ui"),
      div(
        class = "content_footer",
        HTML(
          "<h4><span class = 'accent'>Click
          </span> on any of the artists to get a detailed look at their music.
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          Scroll down for the ranked view</h4>"
        )
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content_header",
        HTML(
          "<h1>Your <span class = 'accent'>all-time</span> favorite
          artists</h1>"
        )
      ),
      div(
        class = "content_table",
        uiOutput("table_alltime_artist_ui")
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        Of course, your listening habits won't always remain the same. As you
        discover new music and artists, some of your <span class = 'accent'>
        all-time</span> favorite artists will have to make way for others.
        Who might they be?  Let's take a look at which artists you listened to
        the most over the last month. Here are your <span class = 'accent'>
        recent</span> favorite artists:
        </p>"
      )
    ),
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
    ),
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
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        After taking a look at the artists you are listening to, we
        will now focus on the songs you listen to regularly. We'll once again
        be looking at your <span class='accent'>all-time</span> favorite
        songs and your most <span class='accent'>recent</span> favorites,
        starting with the first of the two:
        </p>"
      )
    ),
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
        ),#
        div(
          class = "content_footer",
          br(),
          br(),
          HTML(
            "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
          )
        )
      ),
      div(
        class = "modal",
        h1("This is a modal page")
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        And now for the songs that you just can't get enough of in recent
        times. Here are your <span class='accent'>recent</span> favorite songs:
        </p>"
      )
    ),
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
          br(),
          HTML(
            "<h4><span class = 'accent'>Click
          </span> on any of the titles to get a detailed look at the song"
          )
        )
      ),
      div(
        class = "modal",
        h1("This is a modal page")
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        As we grow older, we may stop listening to certain types of music and 
        start exploring new music. <br> 
        In addition, certain events in our lives can temporarily affect the 
        type of music we consume. People listen to <span class = 'accent'>sad
        </span> songs to 
        help them cope with a break-up and to <span class = 'accent'>happier
        </span> music when life is good.
        <br>
        By looking at all the songs that you have saved or that are part of one
        of your playlists, we can look how the types of songs you have listened
        to have changed over time.
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(id = "break"),
      highchartOutput(
        "change_plot",
        width = "60%",
        height = "60%"
      )
    ),
    tags$section(
      class = "content_page",
      HTML(
        "<p>
        The last thing we will be looking at is what kind of songs you are
        listening to and how we can group them. We look at the audio features
        of all your saved songs and songs in playlist and cluster them into
        <span class = 'accent'>ten</span> different groups. <br>
        <span class = 'accent'>Click</span> on any of 
        the clusters to see how
        an average song in that cluster is characterised and what are 
        examples of the songs in there. <br>
        Suprised by the similarity of these 
        songs?
        </p>"
      )
    ),
    tags$section(
      class = "content_page",
      div(
        class = "content_header",
        HTML(
          "<h1><span class = 'accent'>Clustering</span> of your saved
          tracks</h1>"
        )
      ),
      column(
        width = 1
      ),
      column(
        class = "cluster_col",
        width = 2,
        h3(id = "clust_1", "Cluster 1"),
        htmlOutput("clust_1_out", class = "clust_out"),
        h3(id = "clust_2", "Cluster 2"),
        htmlOutput("clust_2_out", class = "clust_out"),
        h3(id = "clust_3", "Cluster 3"),
        htmlOutput("clust_3_out", class = "clust_out"),
        h3(id = "clust_4", "Cluster 4"),
        htmlOutput("clust_4_out", class = "clust_out"),
        h3(id = "clust_5", "Cluster 5"),
        htmlOutput("clust_5_out", class = "clust_out"),
      ),
      column(
        class = "cluster_col",
        width = 6,
        highchartOutput(
          "radarchart",
          width = "100%",
          height = "50%"
        ),
        htmlOutput(
          "song_examples"
        )
      ),
      column(
        class = "cluster_col",
        width = 2,
        h3(id = "clust_6", "Cluster 6"),
        htmlOutput("clust_6_out", class = "clust_out"),
        h3(id = "clust_7", "Cluster 7"),
        htmlOutput("clust_7_out", class = "clust_out"),
        h3(id = "clust_8", "Cluster 8"),
        htmlOutput("clust_8_out", class = "clust_out"),
        h3(id = "clust_9", "Cluster 9"),
        htmlOutput("clust_9_out", class = "clust_out"),
        h3(id = "clust_10", "Cluster 10"),
        htmlOutput("clust_10_out", class = "clust_out"),
      ),
      column(
        width = 1
      ),
      div(class = "content_footer")
    ),
    tags$section()
  ),
  tags$script(
    src = "fullpage.js"
  ),
  tags$script(
    src = "animate.js"
  ),
  tags$script(
    src = "https://isuttell.github.io/sine-waves/javascripts/sine-waves.min.js"
  ),
  tags$script(
    src = "waves.js"
  ),
  tags$script(
    src='https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.17-beta.0/vue.js'
  ),
  tags$script(
    src='https://cdnjs.cloudflare.com/ajax/libs/localforage/1.7.3/localforage.min.js'
  )
)
