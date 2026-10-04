sysfonts::font_add_google("Amatic SC", "Amatic+SC")
## Automatically use showtext to render text for future devices
showtext::showtext_auto()

dino <- dplyr::filter(datasauRus::datasaurus_dozen, dataset == "dino")

p1 <- ggplot2::ggplot(dino, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point(size = .75) +
  ggplot2::theme(legend.position = "none") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 10, family = "Amatic+SC")) +
  ggplot2::labs(title = "The datasauRus and friends") +
  ggplot2::theme(plot.title = ggplot2::element_text(size = 18, face = "bold")) +
  ggplot2::theme(strip.text.x = ggplot2::element_text(
    size = 14,
    color = "black",
    face = "bold"
  ))


datasaurus_dozen2 <- dplyr::filter(
  datasauRus::datasaurus_dozen,
  dataset == "away" |
    dataset == "bullseye" |
    dataset == "circle" |
    dataset == "dots" |
    dataset == "star" |
    dataset == "x_shape"
)


p2 <- ggplot2::ggplot(datasaurus_dozen2, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point(size = .75) +
  ggplot2::theme(legend.position = "none") +
  ggplot2::facet_wrap( ~ dataset, ncol = 2) +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 10, family = "Amatic+SC")) +
  ggplot2::theme(strip.text.x = ggplot2::element_text(
    size = 14,
    color = "black",
    face = "bold"
  ))

cowplot::plot_grid(p1, p2)