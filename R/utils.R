

#' Print a quote
#' @export
print.quote <- function(x, width = NULL) {
  # from statqutoes::print.statquote
  if (is.null(width))
    width <- 0.9 * getOption("width")
  if (width < 10)
    stop("'width' must be greater than 10", call. = FALSE)
  x <- x[, c("text", "source")]
  if (nrow(x) > 1) {
    for (i in 1L:nrow(x)) {
      print(x[i, ], width = width, ...)
      if (i < nrow(x))
        cat("\n")
    }
  }
  else {
    x$source <- paste("---", x$source)
    sapply(strwrap(x, width), cat, "\n")
  }
  invisible()
}
