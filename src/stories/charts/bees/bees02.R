library(palmerpenguins)
library(ggplot2)
library(ggbeeswarm)

ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_violin(
    alpha = 0.25,
    color = NA,
    trim = FALSE
  ) +
  geom_beeswarm(
    aes(color = species),
    size = 2,
    alpha = 0.7
  ) +
  scale_fill_manual(
    values = c(
      "Adelie" = "#E69F00",
      "Chinstrap" = "#56B4E9",
      "Gentoo" = "#009E73"
    )
  ) +
  scale_color_manual(
    values = c(
      "Adelie" = "#D55E00",
      "Chinstrap" = "#0072B2",
      "Gentoo" = "#009E73"
    )
  ) +
  labs(
    title = "Penguin Body Mass by Species",
    subtitle = "Distribution and individual observations",
    x = NULL,
    y = "Body mass (g)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )



