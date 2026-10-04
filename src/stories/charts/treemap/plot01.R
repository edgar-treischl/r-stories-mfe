library(ggplot2)
library(treemapify)

df <- data.frame(
  Dimensions = c(
    "Science Technology",
    "Life Science Biomedicine",
    "Social Sciences",
    "Physical Sciences",
    "Art & Humanities",
    "Technology"
  ),
  number = c(5475, 5364, 4217, 610, 657, 491)
)

ggplot(df, aes(area = number, fill = number, label = Dimensions)) +
  geom_treemap(colour = "white", linewidth = 0.5) +
  geom_treemap_text(
    colour = "white",
    fontface = "bold",
    place = "centre",
    grow = TRUE,
    reflow = TRUE
  ) +
  scale_fill_viridis_c(option = "H", guide = "none") +
  theme_void()