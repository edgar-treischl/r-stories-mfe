my_theme <- function(
    base_size = 12,
    base_family = "Helvetica"
) {
  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family
  ) +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        face = "bold",
        size = 16
      ),
      plot.background = ggplot2::element_rect(
        fill = "ghostwhite",
        colour = "white"
      ),
      panel.grid = ggplot2::element_blank(),
      legend.position = "none",
      legend.title = ggplot2::element_blank()
    )
}


find_small_squares <- function(df, n) {
  
  stopifnot(
    is.data.frame(df),
    n >= 1,
    n < nrow(df)
  )
  
  df_x <- df |>
    dplyr::arrange(x) |>
    dplyr::mutate(
      x_lead = dplyr::lead(x),
      x_gap = x_lead - x
    ) |>
    dplyr::slice_min(
      x_gap,
      n = n,
      with_ties = FALSE
    ) |>
    dplyr::select(x, x_lead)
  
  df_y <- df |>
    dplyr::arrange(y) |>
    dplyr::mutate(
      y_lead = dplyr::lead(y),
      y_gap = y_lead - y
    ) |>
    dplyr::slice_min(
      y_gap,
      n = n,
      with_ties = FALSE
    ) |>
    dplyr::select(y, y_lead)
  
  df_x |>
    dplyr::bind_cols(df_y) |>
    dplyr::mutate(
      color = sample(3, dplyr::n(), replace = TRUE)
    )
}



make_paris <- function(seed = 1023) {
  
  set.seed(seed)
  
  df <- data.frame(
    x = c(1, 3, 2, 5),
    y = c(3, 8, 7, 1)
  )
  
  df_add <- data.frame(
    z = c(2, 5, 2, 3, 1, 5, 6, 7, 7.5)
  ) |>
    dplyr::mutate(
      color = sample(3, dplyr::n(), replace = TRUE),
      x = sample(
        df$x,
        dplyr::n(),
        replace = TRUE
      ),
      xend = sample(
        df$x,
        dplyr::n(),
        replace = TRUE
      )
    )
  

  
  df_rect <- find_small_squares(df, 3)
  
  pal <- c(
    "#255293",
    "#db0a16",
    "#f8c72d"
  )
  
  
  ggplot2::ggplot(df) +
    ggplot2::geom_vline(
      xintercept = df$x,
      linewidth = 5
    ) +
    ggplot2::geom_hline(
      yintercept = df$y,
      linewidth = 5
    ) +
    ggplot2::geom_segment(
      data = df_add,
      ggplot2::aes(
        x = x,
        xend = xend,
        y = z,
        yend = z
      ),
      linewidth = 5
    ) +
    ggplot2::geom_rect(
      data = df_rect,
      ggplot2::aes(
        xmin = x + 0.045,
        xmax = x_lead - 0.045,
        ymin = y + 0.065,
        ymax = y_lead - 0.065,
        fill = factor(color)
      )
    ) +
    ggplot2::scale_fill_manual(values = pal) +
    my_theme()
}



make_new_york <- function(seed = 1023) {
  
  set.seed(seed)
  
  pal <- c(
    "#255293",   # blue
    "#db0a16",   # red
    "#f8c72d",   # yellow
    "ghostwhite" # white
  )
  
  
  df <- data.frame(
    x = sort(sample(0:18, 7)),
    y = sort(sample(0:18, 7))
  )
  
  
  df_rect <- expand.grid(
    x = df$x[-length(df$x)],
    x_lead = df$x[-1],
    y = df$y[-length(df$y)],
    y_lead = df$y[-1]
  )
  
  df_rect <- df_rect |>
    dplyr::filter(
      x_lead > x,
      y_lead > y
    ) |>
    dplyr::mutate(
      color = 4L
    )
  
  
  n_coloured <- max(
    3,
    round(0.15 * nrow(df_rect))
  )
  
  coloured_cells <- sample(
    seq_len(nrow(df_rect)),
    n_coloured
  )
  
  df_rect$color[coloured_cells] <- sample(
    1:3,
    length(coloured_cells),
    replace = TRUE
  )
  

  
  vertical_lines <- data.frame(
    x = df$x
  )
  
  horizontal_lines <- data.frame(
    y = df$y
  )
  
  
  ggplot2::ggplot() +
    
    # Coloured fields
    ggplot2::geom_rect(
      data = df_rect,
      ggplot2::aes(
        xmin = x,
        xmax = x_lead,
        ymin = y,
        ymax = y_lead,
        fill = factor(color)
      ),
      colour = NA
    ) +
    
    # Vertical grid
    ggplot2::geom_vline(
      data = vertical_lines,
      ggplot2::aes(xintercept = x),
      linewidth = 3.5,
      colour = "#f8c72d"
    ) +
    
    # Horizontal grid
    ggplot2::geom_hline(
      data = horizontal_lines,
      ggplot2::aes(yintercept = y),
      linewidth = 3.5,
      colour = "#f8c72d"
    ) +
    
    ggplot2::scale_fill_manual(
      values = pal
    ) +
    
    my_theme()
}


paris <- make_paris()
paris
