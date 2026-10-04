library(ggplot2)

df <- data.frame(
  Dimension = rep(LETTERS[1:7], 2),
  Sex = factor(
    rep(c("Men", "Women"), each = 7),
    levels = c("Men", "Women")
  ),
  Values = c(
    16, 16, 15, 17, 9, 3, 1,
    -11, -1, -5, -1, -10, -11, -19
  )
)

ggplot(df, aes(x = Dimension, y = Values, fill = Sex)) +
  geom_col(width = 0.75) +
  geom_hline(
    yintercept = 0,
    colour = "grey40",
    linewidth = 0.5
  ) +
  coord_flip() +
  scale_y_continuous(
    limits = c(-20, 20),
    breaks = seq(-20, 20, 5),
    labels = abs
  ) +
  scale_fill_brewer(
    palette = "Paired",
    guide = guide_legend(reverse = TRUE)
  ) +
  labs(
    x = NULL,
    y = "Value",
    fill = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom"
  )