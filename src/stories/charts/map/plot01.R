library(sf)
library(dplyr)
library(ggplot2)
library(ggtext)

low_colour <- "#F1F5F8"
mid_colour <- "#8FB8CE"
high_colour <- "#155A8A"

text_colour <- "#172B3A"
border_colour <- "#FFFFFF"
label_fill <- "#FFFFFF"
label_border <- "#D7E0E6"
missing_colour <- "#E2E6E9"

bayern_rb <- sf::read_sf("src/stories/plots/map/bayern_rb.gpkg")

daten <- tibble::tribble(
  ~regierungsbezirk, ~metric,
  "Oberbayern", 12,
  "Niederbayern", 8,
  "Oberpfalz", 15,
  "Oberfranken", 20,
  "Mittelfranken", 5,
  "Unterfranken", 17,
  "Schwaben", 10
)

karte <- bayern_rb %>%
  left_join(
    daten,
    by = c("NAME_LATN" = "regierungsbezirk")
  )

label_points <- sf::st_point_on_surface(karte)

label_coordinates <- sf::st_coordinates(label_points)

label_points <- label_points %>%
  sf::st_drop_geometry() %>%
  mutate(
    x = label_coordinates[, 1],
    y = label_coordinates[, 2],
    label = paste0(
      "<span style='font-size:8pt; color:", text_colour, ";'>",
      NAME_LATN,
      "</span><br>",
      "<span style='font-size:10pt; font-weight:400; color:", text_colour, ";'>",
      scales::number(
        metric,
        accuracy = 0.1,
        decimal.mark = ","
      ),
      "</span>"
    )
  )

ploti <- ggplot(karte) +
  geom_sf(
    aes(fill = metric),
    colour = border_colour,
    linewidth = 0.2
  ) +
  ggtext::geom_richtext(
    data = label_points,
    aes(
      x = x,
      y = y,
      label = label
    ),
    inherit.aes = FALSE,
    colour = text_colour,
    fill = scales::alpha(label_fill, 0.78),
    label.colour = scales::alpha(label_border, 0.9),
    label.size = 0.25,
    label.padding = grid::unit(
      c(0.25, 0.5, 0.25, 0.5),
      "lines"
    ),
    label.r = grid::unit(0.2, "lines"),
    size = 3,
    lineheight = 0.9,
    family = "sans",
    hjust = 0.5,
    vjust = 0.5
  ) +
  scale_fill_gradientn(
    colours = c(
      low_colour,
      mid_colour,
      high_colour
    ),
    limits = c(5, 20),
    name = "Example Indicator",
    breaks = c(5, 10, 15, 20),
    labels = scales::label_number(
      accuracy = 0.1,
      decimal.mark = ","
    ),
    na.value = missing_colour,
    guide = guide_colourbar(
      title.position = "top",
      title.hjust = 0,
      label.position = "bottom",
      barwidth = grid::unit(10, "cm"),
      barheight = grid::unit(0.4, "cm"),
      ticks = TRUE,
      ticks.colour = text_colour,
      frame.colour = NA,
      nbin = 256
    )
  ) +
  labs(
    title = "Example Values",
    subtitle = "Values by administrative region",
    x = NULL,
    y = NULL
  ) +
  coord_sf(
    datum = NA,
    expand = TRUE,
    clip = "off"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(
      colour = text_colour,
      face = "bold",
      size = 15,
      hjust = 0,
      margin = margin(
        b = 3
      )
    ),
    plot.subtitle = element_text(
      colour = scales::alpha(text_colour, 0.75),
      size = 9.5,
      hjust = 0,
      margin = margin(
        b = 10
      )
    ),
    legend.position = "none",
    legend.direction = "horizontal",
    legend.justification = "center",
    legend.title = element_text(
      colour = text_colour,
      face = "bold",
      size = 9,
      hjust = 0
    ),
    legend.text = element_text(
      colour = text_colour,
      size = 8
    ),
    legend.key.width = grid::unit(
      0.8,
      "cm"
    ),
    legend.key.height = grid::unit(
      0.4,
      "cm"
    ),
    legend.spacing.x = grid::unit(
      0.15,
      "cm"
    ),
    legend.margin = margin(
      t = 5,
      r = 0,
      b = 0,
      l = 0
    ),
    plot.margin = margin(
      t = 8,
      r = 8,
      b = 5,
      l = 8
    )
  )

ploti