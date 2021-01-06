library(dotenv)
library(dplyr)
library(highcharter)
library(httr)
library(lubridate)
library(mlr)
library(plyr)
library(rlist)
library(shiny)
library(shinybusy)
library(shinyjs)
library(shinyWidgets)
library(spotifyr)
library(sass)
library(stringr)
library(waiter)
local <- TRUE
if (interactive()) {
  # testing url
  options(shiny.port = 1410)
  REDIRECT_URI <- 'http://localhost:1410/'
} else {
  # deployed URL
  REDIRECT_URI <- 'http://rcharlie.net/SpotiFest/'
}
load_dot_env("spotify_client.env")
auth_url <- GET('https://accounts.spotify.com/authorize',
                query = list(
                  client_id = Sys.getenv('SPOTIFY_CLIENT_ID'),
                  response_type = 'token',
                  redirect_uri = REDIRECT_URI,
                  scope = 'user-top-read'
                )) %>% .$url

jscode <- "app.get('/login', function(req, res) {
var scopes = 'user-read-private user-read-email';
res.redirect('https://accounts.spotify.com/authorize' +
  '?response_type=code' +
  '&client_id=' + 98894b216d4143f5b3f8104668d2fd11 +
  (scopes ? '&scope=' + encodeURIComponent(scopes) : '') +
  '&redirect_uri=' + encodeURIComponent(http://localhost:1410/));
});

"

css <- sass(sass_file("www/styles.scss"))
ui <- source(file.path("ui", "ui.R"), local = TRUE)$value
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  runjs(jscode)
  get_access_token <- reactive({
    url_hash <- getUrlHash()
    access_token <- url_hash %>% str_replace('&.*', '') %>% str_replace('.*=', '')
    access_token
  })
  a <- reactive({
    getUrlHash()
  })
  print("am here")
  print(isolate(get_access_token()))
  print(isolate(a()))
  source(file.path("server", "functions.R"), local = TRUE)$value
  if (local) {
    load("files.RData")
  } else {
    source(file.path("server", "create_spotify_thingys.R"), local = TRUE)$value
  }
  source(file.path("server", "create_html_thingys.R"), local = TRUE)$value
  source(file.path("server", "cluster_react.R"), local = TRUE)$value
  source(file.path("server", "highcharts.R"), local = TRUE)$value
  source(file.path("server", "ui_outputs.R"), local = TRUE)$value
  source(file.path("server", "modal.R"), local = TRUE)$value
  source(file.path("server", "reactive_values.R"), local = TRUE)$value
  source(file.path("server", "event_observer.R"), local = TRUE)$value
  source(file.path("server", "text_outputs.R"), local = TRUE)$value
}

# Run the application
shinyApp(
  ui = ui,
  server = server
)
