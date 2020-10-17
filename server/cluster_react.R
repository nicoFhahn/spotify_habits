clust_number <- reactiveValues(
  val = c(TRUE, rep(FALSE, 9))
)

sample_songs <- reactiveValues(
  val = list(
    sample(
      length(clustered[clustered$cluster == 1, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 2, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 3, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 4, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 5, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 6, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 7, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 8, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 9, ]$tracks[[1]]),
      3
    ),
    sample(
      length(clustered[clustered$cluster == 10, ]$tracks[[1]]),
      3
    )
  )
)

num_clicks <- reactiveValues(
  val = rep(0, 10)
)
onclick(
  "clust_1",
  update_values(1)
)

onclick(
  "clust_2",
  update_values(2)
)

onclick(
  "clust_3",
  update_values(3)
)

onclick(
  "clust_4",
  update_values(4)
)

onclick(
  "clust_5",
  update_values(5)
)

onclick(
  "clust_6",
  update_values(6)
)

onclick(
  "clust_7",
  update_values(7)
)

onclick(
  "clust_8",
  update_values(8)
)

onclick(
  "clust_9",
  update_values(9)
)

onclick(
  "clust_10",
  update_values(10)
)
