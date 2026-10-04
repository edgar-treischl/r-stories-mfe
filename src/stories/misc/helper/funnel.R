library(ggplot2)
library(dplyr)
library(tibble)

data <- tibble(
  x = c(
    "First", "First", "First",
    "Second", "Second", "Second"
  ),
  group = c(
    "A", "B", "C",
    "A", "B", "C"
  ),
  value = c(
    0.4, 0.3, 0.3,
    0.2, 0.5, 0.3
  )
)

bar_width <- 0.3
source_x <- "First"
target_x <- "Second"
source_group <- "B"

source_fraction <- 1


data <- data |>
  mutate(
    x = factor(x, levels = c("First", "Second")),
    group = factor(group, levels = c("A", "B", "C"))
  ) |>
  arrange(
    x,
    desc(group)
  ) |>
  group_by(x) |>
  mutate(
    ymin = cumsum(value) - value,
    ymax = cumsum(value)
  ) |>
  ungroup()



source <- data |>
  filter(
    x == source_x,
    group == source_group
  )



source_x_position <- match(
  source_x,
  levels(data$x)
)

target_x_position <- match(
  target_x,
  levels(data$x)
)


source_height <- source$ymax - source$ymin

source_center <- (source$ymin + source$ymax) / 2

source_ymin <- source_center -
  source_height * source_fraction / 2

source_ymax <- source_center +
  source_height * source_fraction / 2



source_edge <- source_x_position + bar_width / 2

target_edge <- target_x_position - bar_width / 2


funnel <- tibble(
  x = c(
    source_edge,
    target_edge,
    target_edge,
    source_edge
  ),
  y = c(
    source_ymin,
    0,
    1,
    source_ymax
  )
)


# print(data)
# 
# print(
#   source |>
#     select(x, group, value, ymin, ymax)
# )
# 
# print(
#   tibble(
#     source_ymin = source_ymin,
#     source_ymax = source_ymax,
#     source_center = source_center,
#     source_height = source_height
#   )
# )
# 
# print(funnel)

# Plot

funnelplot <- ggplot(
  data,
  aes(
    x = x,
    y = value,
    fill = group
  )
) +
  geom_col(
    width = bar_width
  ) +
  geom_polygon(
    data = funnel,
    aes(
      x = x,
      y = y
    ),
    inherit.aes = FALSE,
    fill = "#40B1EE",
    alpha = 0.25
  ) +
  scale_y_continuous(
    limits = c(0, 1.1),
    breaks = seq(0, 1, 0.25),
    expand = c(0, 0)
  ) +
  scale_fill_manual(
    values = c(
      A = "grey80",
      B = "#E69F00",
      C = "grey60"
    )
  ) +
  labs(
    title = "Data-driven funnel",
    subtitle = "Funnel originates from group B"
  ) +
  theme_minimal()


funnelplot




