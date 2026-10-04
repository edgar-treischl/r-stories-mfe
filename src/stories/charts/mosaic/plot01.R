library(ggplot2)
library(ggmosaic2)

# Built-in Titanic data
titanic_df <- as.data.frame(Titanic)

plot_df <- aggregate(
  Freq ~ Sex + Survived,
  data = titanic_df,
  FUN = sum
)

ggplot(plot_df) +
  geom_mosaic(
    aes(
      x = product(Sex),
      fill = Survived,
      weight = Freq
    )
  ) +
  scale_fill_manual(
    values = c(
      "No" = "#08519c",
      "Yes" = "#6baed6"
    )
  ) +
  labs(
    x = "Sex",
    y = "Proportion",
    title = "Who survived the Titanic?",
    subtitle = "Passenger class, sex, and survival",
    fill = "Survival",
  ) +
  theme_minimal()+
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

