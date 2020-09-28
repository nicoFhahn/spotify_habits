source(file.path("server", "functions.R"), local = TRUE)$value
alltime_grid <- create_random_grid(urls_alltime, "at")
recent_grid <- create_random_grid(urls_recent, "rc")
pairs <- lapply(seq_len(10), seq, to = 20, by = 10)
table_skeleton <- "<tr><td class='col_rank'>rank_1</td><td class='col_name'>name_1</td><td class='col_img'>img_1</td><td>&nbsp;</td><td class='col_rank'>rank_2</td><td class='col_name'>name_2</td><td class='col_img'>img_2</td></tr>"
table_rows_alltime_artist <- lapply(
  pairs,
  skeleton_replacer, 
  longterm_art,
  table_skeleton,
  urls_alltime
)
table_alltime_artist <- paste(
  "<table><tbody>",
  Reduce(paste, table_rows_alltime_artist),
  "</tbody></table>",
  sep = ""
)
table_rows_recent_artist <- lapply(
  pairs,
  skeleton_replacer, 
  shortterm_art,
  table_skeleton,
  urls_recent
)
table_recent_artist <- paste(
  "<table><tbody>",
  Reduce(paste, table_rows_recent_artist),
  "</tbody></table>",
  sep = ""
)
table_rows_alltime_songs <- lapply(
  pairs,
  skeleton_replacer, 
  longterm_tracks,
  table_skeleton,
  urls_alltime_songs
)
table_alltime_songs <- paste(
  "<table><tbody>",
  Reduce(paste, table_rows_alltime_songs),
  "</tbody></table>",
  sep = ""
)
table_rows_recent_songs <- lapply(
  pairs,
  skeleton_replacer, 
  shortterm_tracks,
  table_skeleton,
  urls_recent_songs
)
table_recent_songs <- paste(
  "<table><tbody>",
  Reduce(paste, table_rows_recent_songs),
  "</tbody></table>",
  sep = ""
)
table_recent_songs <- add_id(table_recent_songs, "recent_songs")
iframe_skeleton <- c(
  "<iframe src='placeholder' frameborder='0' allowtransparency='true'
  allow='encrypted-media' background='#242424'></iframe>"
)
