# Spotify Habits
An R Shiny App to visualize and analyse your listening habits. Shows you what your most listened to artists and songs are and further analyzes these. The app also analyzes your general listening behavior and clusters the songs you listend to. And you can create your own playlist!
# Demo
A demo version of the app is available here:

https://nicohahn.shinyapps.io/spotify_habits/

# Run it on your machine
You can run the app on your own machine using the following code:

```R
packages <- c(
	"dotenv", "dplyr", "highcharter", "lubridate", "mlr", "plyr", "rlist",
  "shiny", "shinybusy", "shinyjs", "shinyWidgets", "sass", "stringr"
	)
to_install <- packages[!packages %in% installed.packages()[, "Package"]]
install.packages(to_install, repos = "https://cran.rstudio.com/")
devtools::install_github("charlie86/spotifyr")
library(shiny)
runGitHub("spotify_habits", "nicoFhahn")
```

### Questions/issues/contact
nico@f-hahn.de, or open a GitHub issue
