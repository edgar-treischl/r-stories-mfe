library(ggridges)
library(ggplot2)
library(dplyr)
library(gapminder)

years <- c(1952, 1972, 1992, 2007)

df <- gapminder |>
  filter(
    year %in% years,
    continent != "Oceania"
  ) |>
  mutate(
    year = factor(year, levels = years)
  )

# Order continents by median life expectancy in 2007
continent_order <- df |>
  filter(year == 2007) |>
  group_by(continent) |>
  summarise(
    median_lifeExp = median(lifeExp),
    .groups = "drop"
  ) |>
  arrange(median_lifeExp) |>
  pull(continent)

df <- df |>
  mutate(
    continent = factor(continent, levels = continent_order)
  )

ggplot(
  df,
  aes(
    x = lifeExp,
    y = continent,
    group = interaction(continent, year),
    fill = year
  )
) +
  geom_density_ridges(
    scale = 1.1,
    rel_min_height = 0.01,
    alpha = 0.75,
    colour = "white",
    linewidth = 0.4
  ) +
  scale_fill_viridis_d(
    option = "D",
    direction = 1,
    name = "Year"
  ) +
  scale_x_continuous(
    name = "Life expectancy (years)",
    breaks = seq(40, 80, 10),
    expand = expansion(mult = c(0.02, 0.02))
  ) +
  scale_y_discrete(
    name = NULL,
    expand = expansion(add = c(0.02, 0.02))
  ) +
  labs(
    title = "Distribution of life expectancy by continent",
    subtitle = "Country-level distributions across selected years",
    caption = "Gapminder data · 1952, 1972, 1992, 2007"
  ) +
  theme_minimal(
    base_size = 12
  ) +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold"
    ),
    plot.subtitle = element_text(
      colour = "grey40"
    ),
    plot.caption = element_text(
      colour = "grey50",
      hjust = 0
    ),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(
      face = "bold"
    ),
    axis.title.x = element_text(
      margin = margin(t = 8)
    ),
    legend.title = element_text(
      face = "bold"
    ),
    plot.margin = margin(8, 12, 8, 8)
  )
