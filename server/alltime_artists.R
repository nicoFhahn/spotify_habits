
output$image_1 <- renderUI({
  tags$figure(
    id = "alltime_1",
    class = "card card_bg_red",
    img(
      src = longterm_art$images[[1]][1, 2],
      align = "center",
      class = "card__img"
      ),
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
output$image_2 <- renderUI({
  tags$figure(
    class = "card card_bg_red",
    img(
      src = longterm_art$images[[2]][1, 2],
      align = "center",
      class = "card__img"
      ),
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
    img(
      src = longterm_art$images[[3]][1, 2],
      align = "center",
      class = "card__img"
      ),
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
    img(
      src = longterm_art$images[[4]][1, 2],
      align = "center",
      class = "card__img"
      ),
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
    img(
      src = longterm_art$images[[5]][1, 2],
      align = "center",
      class = "card__img"
      ),
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
    img(
      src = longterm_art$images[[6]][1, 2],
      align = "center",
      class = "card__img"
      ),
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