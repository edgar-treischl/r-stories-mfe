library(tidyverse)
library(palmerpenguins)
library(scales)

# Penguin data
penguins_data <- penguins |>
  drop_na(species) |>
  count(species) |>
  mutate(
    percent = n / sum(n)
  )

# Penguin colors
penguin_colors <- c(
  "Adelie"    = "#2A9D8F",
  "Chinstrap" = "#E9C46A",
  "Gentoo"    = "#264653"
)

# Create 100 tiles
waffle_data <- penguins_data |>
  mutate(tiles = round(percent * 100)) |>
  uncount(tiles) |>
  mutate(
    id = row_number(),
    x = (id - 1) %% 10 + 1,
    y = (id - 1) %/% 10 + 1
  )

# Labels
labels <- penguins_data |>
  mutate(
    label = paste0(
      species, " (",
      percent(percent, accuracy = 1),
      ")"
    )
  ) |>
  select(species, label) |>
  deframe()

# Plot
ggplot(waffle_data, aes(x, y, fill = species)) +
  geom_tile(
    colour = "white",
    linewidth = 0.5
  ) +
  scale_fill_manual(
    values = penguin_colors,
    labels = labels,
    name = NULL
  ) +
  coord_equal() +
  scale_y_reverse() +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(
    title = "Palmer Penguins",
    subtitle = "Each square represents 1% of penguins",
    caption = "Source: palmerpenguins"
  ) +
  theme_void() +
  theme(
    legend.position = "right",
    legend.title = element_text(
      face = "bold",
      color = "#303030"
    ),
    legend.text = element_text(
      color = "#444444"
    ),
    plot.title = element_text(
      size = 14,
      face = "bold",
      color = "#222222",
      margin = margin(b = 5)
    ),
    plot.subtitle = element_text(
      size = 10,
      color = "#666666",
      margin = margin(b = 15)
    ),
    plot.caption = element_text(
      size = 9,
      color = "#888888",
      hjust = 0
    ),
    plot.margin = margin(15, 25, 15, 15)
  )
