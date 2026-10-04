library(palmerpenguins)
library(dplyr)
library(ggplot2)

plot_data_summary <- palmerpenguins::penguins |>
  dplyr::group_by(species) |>
  dplyr::summarise(
    body_mass = mean(body_mass_g, na.rm = TRUE)
  )

ggplot2::ggplot(
  plot_data_summary,
  ggplot2::aes(
    x = species,
    y = body_mass
  )
) +
  ggplot2::geom_col() +
  ggplot2::labs(
    caption = "Average body mass by penguin species",
    x = "Penguin species",
    y = "Average body mass (g)"
  ) +
  ggplot2::theme_minimal()
