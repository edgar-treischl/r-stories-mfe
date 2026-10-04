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
    x = species,
    y = body_mass,
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
    caption = "Average body mass by penguin species and sex",
    x = "Penguin species",
    y = "Average body mass (g)"
  ) +
  ggplot2::theme_minimal()
