library(palmerpenguins)
library(ggplot2)
library(ggbeeswarm)

ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) +
  geom_beeswarm(
    size = 1.4,
    alpha = 0.85,
    priority = "density"
  ) +
  scale_color_manual(
    values = c(
      "Adelie" = "#E69F00",
      "Chinstrap" = "#56B4E9",
      "Gentoo" = "#009E73"
    )
  ) +
  labs(
    title = "Body Mass of Palmer Penguins",
    subtitle = "Individual observations by penguin species",
    x = "Species",
    y = "Body mass (g)",
    color = "Species"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )