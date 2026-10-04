library(palmerpenguins)
library(dplyr)
library(ggplot2)

# Count penguins by species and sex
plot_data_summary <- palmerpenguins::penguins |>
  dplyr::filter(!is.na(sex)) |>
  dplyr::count(
    species,
    sex,
    name = "n_penguins"
  )

# Calculate total penguins per species
plot_data_total <- plot_data_summary |>
  dplyr::group_by(species) |>
  dplyr::summarise(
    n_penguins = sum(n_penguins),
    .groups = "drop"
  )

# Minimum value for displaying labels
min_values <- 20

# Base plot
ploti <- ggplot2::ggplot(
  plot_data_summary,
  ggplot2::aes(
    x = species,
    y = n_penguins,
    fill = sex
  )
) +
  ggplot2::geom_col(
    width = 0.5
  ) +
  ggplot2::scale_fill_manual(
    values = c(
      "female" = "#E69F00",
      "male" = "#56B4E9"
    ),
    name = "Sex"
  ) +
  ggplot2::labs(
    caption = "Number of penguins by species and sex",
    x = "Penguin species",
    y = "Number of penguins"
  ) +
  ggplot2::theme_minimal()

# Add labels
ploti +
  # Labels inside the stacked bars
  ggplot2::geom_text(
    ggplot2::aes(
      label = ifelse(
        n_penguins > min_values,
        n_penguins,
        ""
      )
    ),
    position = ggplot2::position_stack(vjust = 0.5),
    color = "black",
    size = 9 / ggplot2::.pt
  ) +
  # Total labels above each bar
  ggplot2::geom_text(
    data = plot_data_total,
    ggplot2::aes(
      x = species,
      y = n_penguins,
      label = n_penguins
    ),
    inherit.aes = FALSE,
    vjust = -0.7,
    size = 9 / ggplot2::.pt,
    fontface = "bold"
  )
