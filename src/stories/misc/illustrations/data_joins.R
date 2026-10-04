library(patchwork)
library(showtext)

sysfonts::font_add_google("Patua One", "Patua")
showtext::showtext_auto()
dfx <- expand.grid(x = 1:4, y = 1:2)

labels_x <- c(
  "3", "2", "1", "ID",
  "x3", "x2", "x1", "X"
)

colour_x <- c(
  "#74a9cf", "#0570b0", "#045a8d", "#302E2E",
  "#74a9cf", "#0570b0", "#045a8d", "#302E2E"
)


p1 <- ggplot2::ggplot(dfx, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_x) +
  ggplot2::geom_text(ggplot2::aes(label = labels_x),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::labs(title = "Data joins of data A and B") +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua")) +
  ggplot2::theme(plot.title = ggplot2::element_text(size = 22, face = "bold"))



labels_y <- c(
  "4", "2", "1", "ID",
  "y4", "y2", "y1", "Y"
)
colour_y <- c(
  "#023858", "#0570b0", "#045a8d", "#302E2E",
  "#023858", "#0570b0", "#045a8d", "#302E2E"
)

p2 <- ggplot2::ggplot(dfx, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_y) +
  ggplot2::geom_text(ggplot2::aes(label = labels_y),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua"))



df_ij <- expand.grid(x = 1:3, y = 1:3)


labels_ij <- c(
  "2", "1", "ID",
  "x2", "x1", "X",
  "y2", "y1", "Y"
)
colour_ij <- c(
  "#0570b0", "#045a8d", "#302E2E",
  "#0570b0", "#045a8d", "#302E2E",
  "#0570b0", "#045a8d", "#302E2E"
)

p3 <- ggplot2::ggplot(df_ij, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(
    color = "white",
    linewidth = 1, fill = colour_ij
  ) +
  ggplot2::geom_text(ggplot2::aes(label = labels_ij),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::ggtitle("A: Inner join") +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua"))




df_fj <- expand.grid(x = 1:5, y = 1:3)


labels_fj <- c(
  "4", "3", "2", "1", "ID",
  "NA", "x3", "x2", "x1", "X",
  "y4", "NA", "y2", "y1", "Y"
)
colour_fj <- c(
  "#023858", "#74a9cf", "#0570b0", "#045a8d", "#302E2E",
  "#c1121f", "#74a9cf", "#0570b0", "#045a8d", "#302E2E",
  "#023858", "#c1121f", "#0570b0", "#045a8d", "#302E2E"
)

p4 <- ggplot2::ggplot(df_fj, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_fj) +
  ggplot2::geom_text(ggplot2::aes(label = labels_fj),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::ggtitle("B: Full join") +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua"))




df_lj <- expand.grid(x = 1:4, y = 1:3)

labels_lj <- c(
  "3", "2", "1", "ID",
  "x3", "x2", "x1", "X",
  "NA", "y2", "y1", "Y"
)
colour_lj <- c(
  "#74a9cf", "#0570b0", "#045a8d", "#302E2E",
  "#74a9cf", "#0570b0", "#045a8d", "#302E2E",
  "#c1121f", "#0570b0", "#045a8d", "#302E2E"
)

p5 <- ggplot2::ggplot(df_lj, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(
    color = "white",
    linewidth = 1, fill = colour_lj
  ) +
  ggplot2::geom_text(ggplot2::aes(label = labels_lj),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::ggtitle("C: Left join") +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua"))


df_rj <- expand.grid(x = 1:4, y = 1:3)

labels_rj <- c(
  "4", "2", "1", "ID",
  "y4", "y2", "y1", "Y",
  "NA", "x2", "x1", "X"
)
colour_rj <- c(
  "#023858", "#0570b0", "#045a8d", "#302E2E",
  "#023858", "#0570b0", "#045a8d", "#302E2E",
  "#c1121f", "#0570b0", "#045a8d", "#302E2E"
)

p6 <- ggplot2::ggplot(df_rj, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_tile(color = "white", linewidth = 1, fill = colour_rj) +
  ggplot2::geom_text(ggplot2::aes(label = labels_rj),
                     color = "white",
                     size = 5, family = "Patua"
  ) +
  ggplot2::coord_flip() +
  ggplot2::ggtitle("D: Right join") +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Patua"))

patch <- (p1 | p2) / (p3 | p4) / (p5 | p6)
patch