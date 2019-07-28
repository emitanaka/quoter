sq_get_quote <- function(topic = NULL) {
  quote <- statquotes::statquote(topic = topic)
  class(quote) <- c("quote", class(quote))
  quote
}

