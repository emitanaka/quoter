dj_get_joke <- function() {
  quote <- data.frame(
    topic = "dad joke",
    text = suppressMessages(dadjoke::groan(sting = FALSE)),
    source = "Dad Joke"
  )
  class(quote) <- c("quote", class(quote))
  quote
}

