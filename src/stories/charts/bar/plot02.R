library(palmerpenguins)
library(dplyr)
library(ggplot2)

plot_data_summary <- palmerpenguins::penguins |>
  dplyr::filter(!is.na(sex)) |>
  dplyr::group_by(species, sex) |>
  dplyr::summarise(
    body_mass = mean(body_mass_g, na.rm = TRUE),
    .groups = "drop"
  )

ggplot2::ggplot(
  plot_data_summary,
  ggplot2::aes(
    x = sex,
    y = body_mass,
  )
) +
  ggplot2::geom_col() +
  ggplot2::labs(
    caption = "Average body mass by sex and penguin species",
    x = "Sex",
    y = "Average body mass (g)"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::coord_flip() +
  ggplot2::facet_wrap(~species, ncol = 3)
