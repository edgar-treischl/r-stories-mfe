show_col_named <- function(colours,
                           labels = TRUE,
                           borders = NULL,
                           cex_label = 1,
                           ncol = NULL,
                           max_label_length = 15) {
  if (!is.character(colours)) {
    stop("`colours` must be a character vector.")
  }
  
  if (is.null(names(colours))) {
    stop("`colours` must be a named vector.")
  }
  
  n <- length(colours)
  
  ncol <- if (is.null(ncol)) {
    ceiling(sqrt(n))
  } else {
    min(ncol, n)
  }
  
  nrow <- ceiling(n / ncol)
  
  # Keep names before padding
  colour_names <- names(colours)
  
  # Pad
  pad <- nrow * ncol - n
  
  if (pad > 0) {
    colours <- c(colours, rep(NA_character_, pad))
    
    colour_names <- c(colour_names, rep(NA_character_, pad))
  }
  
  # Matrix layout
  colours <- matrix(colours,
                    nrow = nrow,
                    ncol = ncol,
                    byrow = TRUE)
  
  colour_names <- matrix(colour_names,
                         nrow = nrow,
                         ncol = ncol,
                         byrow = TRUE)
  
  # Plot
  old <- graphics::par(pty = "s", mar = c(0, 0, 0, 0))
  
  on.exit(graphics::par(old))
  
  size <- max(nrow, ncol)
  
  graphics::plot(
    c(0, ncol),
    c(-nrow, 0),
    type = "n",
    xlab = "",
    ylab = "",
    axes = FALSE,
    asp = 1
  )
  
  graphics::rect(
    base::col(colours) - 1,-base::row(colours),
    base::col(colours),-base::row(colours) + 1,
    col = colours,
    border = borders
  )
  
  if (labels) {
    # Determine black/white text from HCL lightness
    valid <- !is.na(colours)
    
    label_colour <- matrix(NA_character_, nrow = nrow, ncol = ncol)
    
    label_colour[valid] <- ifelse(farver::decode_colour(colours[valid], to = "hcl")[, "l"] > 50,
                                  "black",
                                  "white")
    
    # Shorten/wrap names
    display_names <- colour_names
    
    display_names[!is.na(display_names)] <- vapply(display_names[!is.na(display_names)], function(x) {
      paste(base::strwrap(x, width = max_label_length), collapse = "\n")
    }, character(1))
    
    # Name
    graphics::text(
      x = base::col(colours) - 0.5,
      y = -base::row(colours) + 0.62,
      labels = display_names,
      col = label_colour,
      cex = cex_label,
      font = 2
    )
    
    # HEX code
    graphics::text(
      x = base::col(colours) - 0.5,
      y = -base::row(colours) + 0.35,
      labels = colours,
      col = label_colour,
      cex = cex_label * 0.8
    )
  }
  
  invisible(colours)
}

bb.farben.schularten <- c(
  "Grundschule" = "#162883",
  "Gymnasium" = "#008dc9",
  "Mittelschule" = "#ffdd00",
  "Realschule" = "#e2001a",
  "Förderzentrum" = "#69bad9",
  "Freie Waldorfschule" = "#8d9dac",
  "Wirtschaftsschule" = "#f28255",
  "Berufsschule" = "#fd8600",
  "Berufsschule z. sp. F." = "#f8b95d",
  "Berufsfachschule" = "#bfbfbf",
  "Berufsfachschule des Gesundheitswesens" = "#3b3b3b",
  "Fachoberschule" = "#a8e03d",
  "Berufsoberschule" = "#cdeb81",
  "Fachschule" = "#926d37",
  "Fachakademie" = "#cbb397",
  "FOS/BOS" = "#a8e03d"
)


#The bb.farben.schularten palette
show_col_named(
  bb.farben.schularten,
  ncol = 4
)
