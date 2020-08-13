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
library(sass)
longdiv <- function(...){
    div(
        ...,
        class = "container",
        style = "height:100vh;"
    )
}
load_dot_env("spotify_client.env")
css <- sass(sass_file("www/style.scss"))
# get_spotify_authorization_code()
# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(
        tags$style(
            css
        ),
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
        ),
        longdiv(
            div(
                id = "stick",
                h1("Your alltime favorite artists", class = "section")
            ),
            fluidRow(
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_1")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_2")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_3")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_4")
                )
            ),
            fluidRow(
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_5")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_6")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_7")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_8")
                )
            ),
            fluidRow(
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_9")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_10")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_11")
                ),
                column(
                    width = 3,
                    class = "colt",
                    uiOutput("image_12")
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    longterm_art <- get_my_top_artists_or_tracks(
        type = "artists",
        time_range = "long_term",
        limit = 20,
        authorization = code
    )
    output$image_1 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[1]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[1]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[1]][1]
                )
            )
        )
    })
    output$image_2 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[2]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[2]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[2]][1]
                )
            )
        )
    })
    output$image_3 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[3]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[3]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[3]][1]
                )
            )
        )
    })
    output$image_4 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[4]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[4]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[4]][1]
                )
            )
        )
    })
    output$image_5 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[5]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[5]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[5]][1]
                )
            )
        )
    })
    output$image_6 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[6]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[6]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[6]][1]
                )
            )
        )
    })
    output$image_7 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[7]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[7]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[7]][1]
                )
            )
        )
    })
    output$image_8 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[8]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[8]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[8]][1]
                )
            )
        )
    })
    output$image_9 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[9]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[9]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[9]][1]
                )
            )
        )
    })
    output$image_10 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[10]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[10]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[10]][1]
                )
            )
        )
    })
    output$image_11 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[11]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[11]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[11]][1]
                )
            )
        )
    })
    output$image_12 <- renderUI({
        tags$figure(
            class = "card card_bg_red",
            img(src= longterm_art$images[[12]][1, 2], align = "center", class = "card__img"),
            tags$figcaption(
                class = "card__text-block",
                h2(
                    class = "card__heading",
                    longterm_art$name[12]
                ),
                p(
                    class = "card__text",
                    longterm_art$genres[[12]][1]
                )
            )
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
