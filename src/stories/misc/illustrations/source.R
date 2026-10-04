




boxplot_illustration <- function() {
  sysfonts::font_add_google("Lato", "lato")
  
  showtext::showtext_auto()
  
  median_mpg <- median(mtcars$mpg)
  min_mpg <- min(mtcars$mpg)
  max_mpg <- max(mtcars$mpg)
  
  
  intern_p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg)) +
    ggplot2::geom_boxplot() +
    ggplot2::coord_flip()
  
  
  dat <- ggplot2::ggplot_build(intern_p)$data[[1]]
  
  plot <- mtcars |>
    ggplot2::ggplot(ggplot2::aes(y = mpg)) +
    ggplot2::geom_boxplot(outlier.colour = "#C51717", colour = "black") +
    ggplot2::geom_segment(
      data = dat, ggplot2::aes(
        y = xmiddle, yend = xmiddle,
        x = ymin, xend = ymax
      ),
      colour = "#C51717", size = 1.5
    ) +
    ggplot2::coord_flip() +
    ggplot2::theme_minimal() +
    ggplot2::xlab("") +
    ggplot2::ylab("") +
    # median
    ggplot2::annotate("text", y = median_mpg, x = 0.42, label = "Median") +
    # max
    ggplot2::annotate("text",
                      y = max_mpg - 1, x = -.52,
                      label = "Maximum"
    ) +
    ggplot2::geom_segment(
      ggplot2::aes(
        x = -0.04, y = max_mpg - 1.3, # median
        xend = -.45, yend = max_mpg - 1.3
      ),
      arrow = ggplot2::arrow(length = ggplot2::unit(0.5, "cm")),
      size = 1
    ) +
    # outliers
    ggplot2::annotate("text",
                      y = 36.5, x = 0,
                      label = "Potential\noutliers",
                      color = "#C51717",
                      family = "lato"
    ) +
    # min
    ggplot2::annotate("text", y = min_mpg, x = -.52, label = "Minimum") +
    ggplot2::geom_segment(
      ggplot2::aes(
        x = -0.04, y = min_mpg, # median
        xend = -.45, yend = min_mpg
      ),
      arrow = ggplot2::arrow(length = ggplot2::unit(0.5, "cm")),
      size = 1
    ) +
    # geom_brace(aes(c(-.38, -0.48), c(15.425, 22.800), label = ""),
    # inherit.data = F, labelsize = 5, rotate = 270
    # ) +
    ggplot2::annotate("text", y = 19.9, x = -.52, label = "Interquartile range") +
    ggplot2::ylim(5, 40) +
    ggplot2::xlim(-.65, .5) +
    ggplot2::theme(text = ggplot2::element_text(size = 16, family = "lato"))
  
  dots <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) +
    ggplot2::geom_dotplot(
      binwidth = .65,
      fill = "#939191",
      color = "#939191"
    ) +
    ggplot2::scale_y_continuous(NULL, breaks = NULL) +
    ggplot2::theme_void()
  
  cowplot::ggdraw() +
    cowplot::draw_plot(plot,
                       x = 0, y = .15,
                       width = 1, height = .8
    ) +
    cowplot::draw_plot(dots,
                       x = 0.21, y = 0,
                       width = 0.642, height = .9
    )
}


# Boxplot pitfalls

boxplot_pitfalls <- function() {
  sysfonts::font_add_google("Patua One", "Patua")
  showtext::showtext_auto()
  
  data <- data.frame(
    Group = c(rep("A", 100), rep("B", 500), rep("C", 15)),
    Outcome = c(rnorm(100, 12, 1), rnorm(500, 13, 1), rnorm(15, 20, 4))
  )
  
  sample_size <- data |>
    dplyr::group_by(Group) |>
    dplyr::summarize(num = dplyr::n())
  
  data <- data |>
    dplyr::left_join(sample_size) |>
    dplyr::mutate(Groups = paste0(Group, "\n", "n=", num))
  
  p1 <- data |>
    ggplot2::ggplot(ggplot2::aes(
      x = Group, y = Outcome,
      color = Group
    )) +
    ggplot2::geom_boxplot() +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::scale_color_manual(values = c(rep("#969696", 4))) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::ggtitle("A: A boxplot ...") +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua"))
  
  
  # Plot B
  p2 <- data |>
    ggplot2::ggplot(ggplot2::aes(
      x = Groups,
      y = Outcome,
      color = Group
    )) +
    ggplot2::geom_boxplot() +
    ggplot2::geom_jitter(color = "#d62828", size = 0.5, alpha = 0.6) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::scale_color_manual(values = c(rep("#969696", 4))) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::ggtitle("B: A jitter boxplot") +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua"))
  
  # gridExtra::grid.arrange(p1, p2, ncol = 2)
  cowplot::plot_grid(p1, p2)
}







gapminder_plot <- function() {
  gapminder::gapminder |>
    dplyr::filter(year == 2007) |>
    dplyr::mutate(pop = pop / 1000000) |>
    dplyr::arrange(desc(pop)) |>
    ggplot2::ggplot(ggplot2::aes(
      x = log(gdpPercap),
      y = lifeExp,
      size = pop,
      color = continent
    )) +
    ggplot2::geom_point(alpha = 0.7) +
    ggplot2::scale_size(
      range = c(.1, 25),
      guide = "none"
    ) +
    # scale_x_continuous(limits = c(5, 12.5)) +
    ggplot2::scale_y_continuous(limits = c(30, 90)) +
    viridis::scale_color_viridis(
      discrete = TRUE, name = "Region", option = "viridis"
    ) +
    ggplot2::labs(
      x = "GDP per capita (Log)",
      y = "Life expectancy (2007)",
      caption = "Data: Gapminder"
    ) +
    ggplot2::theme_minimal(base_size = 16) +
    ggplot2::guides(color = ggplot2::guide_legend(
      override.aes = list(size = 4),
      reverse = TRUE
    ))
}


leakypipeline_plot <- function() {
  sysfonts::font_add_google("Patua One", "Patua")
  showtext::showtext_auto()
  
  leaky_pipeline <- tibble::tribble(
    ~Gruppe, ~`2017`, ~`2018`, ~`2019`,     ~Sex,
    "Studierende",     485,     489,     493, "Frauen",
    "Absolventen",     508,     511,     517, "Frauen",
    "Promotion",     448,     452,     454, "Frauen",
    "Habilitation",     293,     316,     319, "Frauen",
    "C4-Professur",     115,     117,     117, "Frauen",
    "Studierende",     515,     511,     507, "Männer",
    "Absolventen",     492,     489,     483, "Männer",
    "Promotion",     552,     548,     546, "Männer",
    "Habilitation",     707,     684,     681, "Männer",
    "C4-Professur",     885,     883,     883, "Männer"
  )
  
  leaky_pipeline$Gruppe <- factor(leaky_pipeline$Gruppe, 
                                  levels = c("Studienanfänger", 
                                             "Studierende",
                                             "Absolventen", 
                                             "Promotion", 
                                             "Habilitation", 
                                             "C4-Professur"))
  
  
  
  
  ggplot2::ggplot(leaky_pipeline, ggplot2::aes(x=Gruppe, y=`2019`, group = Sex, color = Sex)) +
    ggplot2::geom_line(size = 1.5) +
    ggplot2::geom_point(size = 2.5)+
    ggplot2::theme_minimal(base_size = 14)+
    ggplot2::geom_label(data = leaky_pipeline |> dplyr::filter(Gruppe == "Promotion"),
                        ggplot2::aes(label = Sex, color = Sex),
                        #hjust = 1.0,
                        #vjust = 0.5,
                        fontface = "bold",
                        size = 5.5,
                        family="Patua")+
    ggplot2::labs(caption = "Daten: destatis.de",
                  y = "Anzahl nach akademischer Laufbahn (2019)")+
    ggplot2::theme(legend.position="none")+
    ggplot2::scale_color_manual(values = c("#264653", "#e76f51"))+
    ggplot2::theme(text=ggplot2::element_text(family="Patua"))
  
}





long_wide_plot <- function() {
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
  
}



pacman_plot <- function(variables) {
  sysfonts::font_add_google("Press Start 2P", "Press Start 2P")
  ## Automatically use showtext to render text for future devices
  showtext::showtext_auto()
  
  df <- tidyr::tribble(
    ~Charts, ~Amount,
    "Resembles", 80.0,
    "Does not resemble", 20.0
  )
  
  
  # Very reduce blank theme
  blank_theme <- ggplot2::theme_minimal(base_size = 10) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.subtitle = ggplot2::element_text(size = 12),
      plot.title = ggplot2::element_text(size = 16)
    )
  
  
  ggplot2::ggplot(df, ggplot2::aes(x = "", y = Amount, fill = Charts)) +
    ggplot2::geom_bar(width = 60, stat = "identity", colour = "black") +
    ggplot2::coord_polar("y", start = pi / 1.5) +
    ggplot2::scale_fill_manual(values = c("white", "#ffff00")) +
    blank_theme +
    ggplot2::theme(legend.position = "right") +
    ggplot2::theme(text = ggplot2::element_text(family = "Press Start 2P")) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE)) +
    ggplot2::labs(
      title = "Pie Charts and Pac-Man",
      subtitle = "How many resemble a Pac-Man?",
      fill = " "
    )
}




simpson_plot <- function() {
  sysfonts::font_add_google("Patua One", "Patua")
  showtext::showtext_auto()
  
  set.seed(1)
  a <- data.frame(
    x = 5 + rnorm(100),
    y = 5 + rnorm(100)
  ) |> dplyr::mutate(y = y - x / 4)
  c <- a |>
    dplyr::mutate(x = x + 2) |>
    dplyr::mutate(y = y + 2)
  simps_df <- do.call(rbind, list(a, c))
  simps_df <- simps_df |> dplyr::mutate(Sex = rep(c("Men", "Women"), each = 100))
  
  p1 <- ggplot2::ggplot(simps_df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(size = 2, color = "black") +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::geom_smooth(
      method = "lm", formula = y ~ x,
      color = "#C51717", se = FALSE
    ) +
    ggplot2::labs(title = "Simpson's Paradox") +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua")) +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 24, face = "bold"))
  
  
  df_text <- data.frame(
    x = c(8, 8),
    y = c(5.5, 2.9),
    text = c("Women", "Men")
  )
  
  
  p2 <- ggplot2::ggplot(simps_df) +
    ggplot2::geom_point(ggplot2::aes(x = x, y = y, color = Sex), size = 2) +
    ggplot2::geom_smooth(ggplot2::aes(x = x, y = y, color = Sex),
                         method = "lm", formula = y ~ x, se = FALSE, fullrange = TRUE
    ) +
    ggplot2::scale_colour_manual(values = c("#C51717", "black")) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::geom_label(
      data = df_text,
      ggplot2::aes(x = x, y = y, label = text),
      fill = c("black", "#C51717"),
      size = 5,
      color = c("white", "white")
    ) +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua"))
  
  
  
  cowplot::plot_grid(p1, p2)
}


# library(tidyverse)
# library(patchwork)
# library(showtext)



ucb_plot <- function() {
  sysfonts::font_add_google("Patua One", "Patua")
  showtext::showtext_auto()
  
  df <- as.data.frame(UCBAdmissions)
  
  df2 <- df |>
    dplyr::group_by(Gender, Admit) |>
    dplyr::summarise(
      Freq = sum(Freq)
    ) |>
    dplyr::mutate(Percent = Freq / sum(Freq) * 100)
  
  
  txt <- c("Admitted", "Rejected", "Admitted", "Rejected")
  num <- paste(round(df2$Percent, 2), "%")
  
  p1 <- df2 |>
    ggplot2::ggplot(ggplot2::aes(x = Gender, y = Percent, group = Gender, fill = Admit)) +
    ggplot2::geom_bar(stat = "identity", position = ggplot2::position_stack()) +
    ggplot2::geom_text(ggplot2::aes(label = paste(txt, num, sep = "\n")),
                       position = ggplot2::position_stack(vjust = 0.5),
                       colour = "white", size = 4, fontface = "bold"
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::scale_fill_manual(values = c("#264653", "#C51717")) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE)) +
    ggplot2::labs(
      title = "UCB Admission Rates",
      alt = "UCB Admission Rates by Edgar Treischl"
    ) +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua")) +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 20)) +
    ggplot2::theme(legend.position = "none")
  
  
  df_dep <- df |>
    dplyr::group_by(Dept) |>
    dplyr::mutate(Percent = Freq / sum(Freq) * 100)
  
  Dept.labs <- c(
    `A` = "Department A",
    `C` = "Department C",
    `F` = "Department F"
  )
  
  p2 <- df_dep |>
    dplyr::filter(Dept == "A" | Dept == "F") |>
    ggplot2::ggplot(ggplot2::aes(
      x = Gender, y = Percent, group = Gender,
      fill = Admit
    )) +
    ggplot2::geom_bar(stat = "identity", position = ggplot2::position_stack()) +
    ggplot2::geom_text(ggplot2::aes(label = round(Percent, 2)),
                       position = ggplot2::position_stack(vjust = 0.5),
                       colour = "white", size = 3, fontface = "bold"
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::scale_fill_manual(values = c("#264653", "#C51717")) +
    ggplot2::facet_wrap(. ~ Dept,
                        ncol = 1,
                        labeller = ggplot2::as_labeller(Dept.labs)
    ) +
    ggplot2::theme(strip.text.x = ggplot2::element_text(
      size = 12, color = "black", face = "bold"
    )) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE)) +
    ggplot2::theme(text = ggplot2::element_text(family = "Patua")) +
    ggplot2::theme(legend.position = "none")
  
  cowplot::plot_grid(p1, p2)
}





