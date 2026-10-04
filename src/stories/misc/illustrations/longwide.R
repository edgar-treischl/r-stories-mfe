sysfonts::font_add_google("Patua One", "Patua")
showtext::showtext_auto()
df_long <- expand.grid(x = 1:5, y = 1:4)

labels_long <- c(
  "2", "2", "1", "1", "ID",
  "2", "1", "2", "1", "T",
  "x2", "x1", "x2", "x1", "X",
  "y", "y", "y", "y", "Y"
)
colour_long <- c(
  "#74a9cf", "#74a9cf", "#045a8d", "#045a8d", "#302E2E",
  "#74a9cf", "#74a9cf", "#045a8d", "#045a8d", "#302E2E",
  "#74a9cf", "#74a9cf", "#045a8d", "#045a8d", "#302E2E",
  "#d0d1e6", "#d0d1e6", "#d0d1e6", "#d0d1e6", "#302E2E"
)

p_long <- ggplot2::ggplot(df_long, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_long) +
  ggplot2::geom_text(ggplot2::aes(label = labels_long),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank()
  ) +
  ggplot2::theme(
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
  ) +
  ggplot2::labs(title = "A: Long") +
  ggplot2::theme(text = ggplot2::element_text(
    family = "Patua",
    face = "bold"
  ))




# And wide
df_wide <- expand.grid(x = 1:3, y = 1:4)

labels_wide <- c(
  "2", "1", "ID",
  "x", "x", "X1",
  "x", "x", "X2",
  "y", "y", "Y"
)
colour_wide <- c(
  "#74a9cf", "#045a8d", "#302E2E",
  "#74a9cf", "#045a8d", "#302E2E",
  "#74a9cf", "#045a8d", "#302E2E",
  "#d0d1e6", "#d0d1e6", "#302E2E"
)

p_wide <- ggplot2::ggplot(df_wide, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_wide) +
  ggplot2::geom_text(ggplot2::aes(label = labels_wide),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank()
  ) +
  ggplot2::theme(
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
  ) +
  ggplot2::labs(title = "B: Wide") +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::theme(text = ggplot2::element_text(
    family = "Patua",
    face = "bold"
  ))

cowplot::plot_grid(p_long, p_wide, ncol = 2, rel_widths = c(1, 1))