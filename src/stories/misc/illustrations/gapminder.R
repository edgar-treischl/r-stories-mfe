gapminder::gapminder |>
  dplyr::filter(year == 2007) |>
  dplyr::mutate(pop_m = pop / 1e6) |>
  dplyr::arrange(pop_m) |>
  ggplot2::ggplot(
    ggplot2::aes(
      x = gdpPercap,
      y = lifeExp,
      size = pop_m,
      color = continent
    )
  ) +
  ggplot2::geom_point(
    alpha = 0.7,
    stroke = 0
  ) +
  ggplot2::scale_x_log10(
    breaks = c(
      500, 1000, 2500, 5000,
      10000, 25000, 50000
    ),
    labels = scales::label_dollar(
      accuracy = 1
    )
  ) +
  ggplot2::scale_y_continuous(
    breaks = seq(30, 90, 10)
  ) +
  ggplot2::scale_size(
    range = c(1, 18),
    guide = "none"
  ) +
  ggplot2::coord_cartesian(
    ylim = c(30, 90)
  ) +
  viridis::scale_color_viridis(
    discrete = TRUE,
    option = "viridis",
    name = "Continent"
  ) +
  ggplot2::labs(
    title = "GDP and life expectancy",
    subtitle = "Bubble size represents population",
    x = "GDP per capita",
    y = "Life expectancy",
    caption = "Source: Gapminder"
  ) +
  ggtext::geom_richtext(
    data = data.frame(
      x = 2000,
      y = 44
    ),
    ggplot2::aes(
      x = x,
      y = y
    ),
    label = paste0(
      "<b>Example interpretation:</b><br>",
      "<span style='color:#666666'>",
      "Countries with higher GDP per capita<br>",
      "generally have longer life expectancy.",
      "</span>"
    ),
    hjust = 0,
    vjust = 1,
    size = 3.4,
    lineheight = 0.45,
    family = "sans",
    color = "#333333",
    fill = scales::alpha("white", 0.92),
    label.color = "#D9D9D9",
    label.padding = grid::unit(
      c(0.7, 0.9, 0.7, 0.9),
      "lines"
    ),
    label.r = grid::unit(
      0.15,
      "lines"
    ),
    inherit.aes = FALSE
  ) +
  ggplot2::guides(
    color = ggplot2::guide_legend(
      override.aes = list(
        size = 4,
        alpha = 1
      ),
      reverse = TRUE
    )
  ) +
  ggplot2::theme_minimal(
    base_size = 15
  ) +
  ggplot2::theme(
    plot.title = ggtext::element_markdown(
      size = 21,
      face = "bold",
      color = "#222222",
      margin = ggplot2::margin(
        b = 4
      )
    ),
    plot.subtitle = ggtext::element_markdown(
      size = 12.5,
      color = "#666666",
      lineheight = 1.3,
      margin = ggplot2::margin(
        b = 18
      )
    ),
    axis.title = ggplot2::element_text(
      size = 11.5,
      color = "#333333"
    ),
    axis.text = ggplot2::element_text(
      size = 10.5,
      color = "#555555"
    ),
    panel.grid.major = ggplot2::element_line(
      color = "#E5E5E5",
      linewidth = 0.3
    ),
    panel.grid.minor = ggplot2::element_blank(),
    legend.title = ggplot2::element_text(
      size = 11,
      color = "#333333"
    ),
    legend.text = ggplot2::element_text(
      size = 10,
      color = "#555555"
    ),
    legend.key.height = grid::unit(
      0.7,
      "lines"
    ),
    plot.caption = ggtext::element_markdown(
      size = 9.5,
      color = "#777777",
      hjust = 0,
      margin = ggplot2::margin(
        t = 10
      )
    ),
    plot.margin = ggplot2::margin(
      15, 20, 10, 15
    )
  )
