library(tidyverse)
library(tidytext)
library(showtext)
library(ggwordcloud)


alice <- readr::read_lines(
  "alice.txt"
)

text_df <- tibble(
  line = seq_along(alice),
  text = alice
)



# Tokenize and remove stop words

tidy_books <- text_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word")



# Count words and remove "alice"

df <- tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(
    n > 7,
    word != "alice"
  )



# Font
font_add_google("Delius", "Delius")
showtext_auto()



# Set word orientation

set.seed(123)

df <- df %>%
  mutate(
    angle = sample(
      c(0, 90),
      size = n(),
      replace = TRUE,
      prob = c(0.65, 0.35)
    )
  )


# Plot

ggplot(
  df,
  aes(
    label = word,
    size = n,
    angle = angle
  )
) +
  geom_text_wordcloud_area(
    family = "Delius",
    color = "#3B3B3B",
    rm_outside = TRUE
  ) +
  scale_size_area(
    max_size = 28
  ) +
  labs(
    title = "Alice in Wonderland",
    subtitle = "Words occurring more than seven times",
    caption = "Source: Alice in Wonderland (Lewis Carroll)"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(
      family = "Delius",
      size = 26,
      face = "bold",
      hjust = 0.5,
      margin = margin(
        t = 20,
        b = 5
      )
    ),
    plot.subtitle = element_text(
      family = "Delius",
      size = 13,
      hjust = 0.5,
      color = "#666666",
      margin = margin(
        b = 15
      )
    ),
    plot.caption = element_text(
      size = 9,
      color = "#888888",
      hjust = 1,
      margin = margin(
        t = 10
      )
    ),
    plot.margin = margin(
      t = 25,
      r = 20,
      b = 15,
      l = 20
    ),
    plot.background = element_rect(
      fill = "#FAF9F6",
      color = NA
    ),
    panel.background = element_rect(
      fill = "#FAF9F6",
      color = NA
    )
  )
