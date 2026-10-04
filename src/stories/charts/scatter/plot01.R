library(ggplot2)
library(palmerpenguins)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()


library(ggplot2)
library(palmerpenguins)

ggplot(penguins, aes(bill_length_mm, bill_depth_mm, color = species)) +
  geom_point(size = 2.5, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  scale_color_manual(values = c(
    "Adelie" = "#E69F00",
    "Chinstrap" = "#56B4E9",
    "Gentoo" = "#009E73"
  )) +
  labs(
    title = "Palmer Penguins",
    subtitle = "Association between bill length and depth",
    x = "Bill length (mm)",
    y = "Bill depth (mm)",
    color = "Species"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(
      color = "#E5E5E5",
      linewidth = 0.4
    ),
    axis.text.x = element_text(
      size = 12,
      color = "#303030"
    ),
    axis.text.y = element_text(
      color = "#555555"
    ),
    axis.title.y = element_text(
      color = "#555555",
      margin = margin(r = 10)
    ),
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
      size = 12,
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
