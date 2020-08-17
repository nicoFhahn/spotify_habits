fluidPage(
  useShinyjs(),
  tags$head(
    tags$style(
      css1
    ),
    tags$style(
      css2
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
                  tags$td("#1", style = "width:5%;color:rgb(255,255,255);", class = "top_art"),
                  tags$td(str_to_title(longterm_art$name[1]), class = "top_art")
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
                  tags$td("#2", style = "width:5%;color:rgb(255,255,255);", class = "top_art"),
                  tags$td(str_to_title(longterm_art$name[2]), class = "top_art")
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
                  tags$td("#3", style = "width:5%;color:rgb(255,255,255);", class = "top_art"),
                  tags$td(str_to_title(longterm_art$name[3]), class = "top_art")
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