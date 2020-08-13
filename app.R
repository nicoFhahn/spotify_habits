#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(dotenv)
library(shiny)
library(shinyjs)
library(spotifyr)
library(shticky)
library(waypointer)
longdiv <- function(...){
    div(
        ...,
        class = "container",
        style = "height:100vh;"
    )
}
load_dot_env("spotify_client.env")
# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(
        tags$link(rel = "stylesheet", href = "style.css"),
        tags$link(
            rel = "stylesheet",
            href = "https://use.fontawesome.com/releases/v5.8.1/css/all.css", 
            integrity = "sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf",
            crossorigin = "anonymous"
        )
    ),
    use_shticky(),
    use_waypointer(),
    div(
        id = "stick",
        style = "position:fixed;width:100%;",
        fluidRow(
            column(12),
        )
    ),
    div(
        id = "bg",
        longdiv(
            h1("Your Spotify listening habits", class = "title"),
            br(),
            br(),
            h1(
                "Visualized with highcharts and R",
                class = "subtitle"
            ),
            p(
                style = "text-align:center;",
                "Using spotifyr to access the Spotify API"
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
