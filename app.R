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
library(stringr)
longdiv <- function(...) {
  div(
    ...,
    class = "container",
    style = "height:100vh;"
  )
}
bigbreak <- function(n) {
  HTML(paste(rep("<br></br>", n), collapse = ""))
}
load_dot_env("spotify_client.env")
css <- sass(sass_file("www/style.scss"))
code <- get_spotify_authorization_code()
longterm_art <- get_my_top_artists_or_tracks(
  type = "artists",
  time_range = "long_term",
  limit = 20,
  authorization = code
)
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
    ),
    tags$script(src = "js.js")
  ),
  div(
    id = "bg",
    longdiv(
      div(
        class = "text-holder",
        h1("Your Spotify listening habits")
      ),
      br(),
      br(),
      div(
        class = "text-holder-2", id = "again",
        h1(
          "Visualized with highcharts and R",
        )
      ),
      div(
        class = "text-holder-3", id = "again2",
        p(
          "Using spotifyr to access the Spotify API"
        )
      )
    ),
    bigbreak(20),
    longdiv(
      tags$section(
        fluidRow(
          tags$figure(
            class = "stick",
            h1("Your alltime favorite artists", class = "section")
          ),
          div(
            bigbreak(10),
            tags$figure(
              class = "stick2",
             tags$table(
                 style = "width:100%;color:rgb(255,255,255);",
                 tags$tr(
                     tags$td("#1", style = "width:5%;color:rgb(255,255,255);"),
                     tags$td(str_to_title(longterm_art$name[1]))
                 ),
                 class = "section"
             )
            ),
            fluidRow(
              class = "fade",
              uiOutput("image_1")
            ),
            bigbreak(10),
            tags$figure(
              class = "stick3",
              tags$table(
                  style = "width:100%;color:rgb(255,255,255);",
                  tags$tr(
                      tags$td("#2", style = "width:5%;color:rgb(255,255,255);"),
                      tags$td(str_to_title(longterm_art$name[2]))
                  ),
                  class = "section"
              )
            ),
            fluidRow(
              class = "fade",
              uiOutput("image_2")
            ),
            bigbreak(10),
            tags$figure(
              class = "stick4",
              tags$table(
                  style = "width:100%;color:rgb(255,255,255);",
                  tags$tr(
                      tags$td("#3", style = "width:5%;"),
                      tags$td(str_to_title(longterm_art$name[3]))
                  ),
                  class = "section"
              )
            ),
            fluidRow(
              class = "fade",
              uiOutput("image_3")
            ),
            bigbreak(15)
          )
        )
      ),
      tags$section(
        fluidRow(
          tags$figure(
            class = "stick",
            h1("Your recent favorite artists", class = "section")
          ),
          div(
            tags$article(
              bigbreak(15),
              fluidRow(
                class = "fade",
                uiOutput("image_4")
              ),
              bigbreak(15),
              fluidRow(
                class = "fade",
                uiOutput("image_5")
              ),
              bigbreak(15),
              fluidRow(
                class = "fade",
                uiOutput("image_6")
              ),
              bigbreak(15)
            )
          )
        )
      )
    ),
    longdiv(),
    longdiv(),
    longdiv(),
    longdiv(),
    longdiv(),
    longdiv(),
    longdiv(),
    longdiv()
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$image_1 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[1]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[1]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[1]][1])
        )
      )
    )
  })

  output$caption_1 <- renderUI({
    title <- paste("#1", str_to_title(longterm_art$name[1]))
    print(title)
    tags$figure(
      class = "stick2",
      h4(title, class = "section")
    )
  })

  output$image_2 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[2]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[2]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[2]][1])
        )
      )
    )
  })
  output$image_3 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[3]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[3]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[3]][1])
        )
      )
    )
  })
  output$image_4 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[4]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[4]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[4]][1])
        )
      )
    )
  })
  output$image_5 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[5]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[5]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[5]][1])
        )
      )
    )
  })
  output$image_6 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[6]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[6]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[6]][1])
        )
      )
    )
  })
  output$image_7 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[7]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[7]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[7]][1])
        )
      )
    )
  })
  output$image_8 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[8]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[8]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[8]][1])
        )
      )
    )
  })
  output$image_9 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[9]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[9]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[9]][1])
        )
      )
    )
  })
  output$image_10 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[10]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[10]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[10]][1])
        )
      )
    )
  })
  output$image_11 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[11]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[11]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[11]][1])
        )
      )
    )
  })
  output$image_12 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[12]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[12]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[12]][1])
        )
      )
    )
  })
  output$image_13 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[13]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[13]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[13]][1])
        )
      )
    )
  })
  output$image_14 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[14]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[14]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[14]][1])
        )
      )
    )
  })
  output$image_15 <- renderUI({
    tags$figure(
      class = "card card_bg_red",
      img(src = longterm_art$images[[15]][1, 2], align = "center", class = "card__img"),
      tags$figcaption(
        class = "card__text-block",
        h2(
          class = "card__heading",
          longterm_art$name[15]
        ),
        p(
          class = "card__text",
          str_to_title(longterm_art$genres[[15]][1])
        )
      )
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
