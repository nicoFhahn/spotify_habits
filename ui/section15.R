tags$section(
  class = "content_page",
  div(
    class = "content_header",
    HTML(
      "<h1>Clustering of your <span class = 'accent'>saved</span>
          tracks</h1>"
    )
  ),
  div(
    class = "content_cluster",
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
        height = "100%"
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
    )
  ),
  div(
    class = "content_footer",
    br(),
    br(),
    HTML(
      "<h4><span class = 'accent'>Click
          </span> on any of the clusters to add them to the graphic"
    )
  ),
  HTML(
    "<h5 class = 'github'><a  target = '_blank' href='https://github.com/nicoFhahn/spotify_habits'>GitHub</a><h6>"
  )
)