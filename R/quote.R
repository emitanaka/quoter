

#' Supported sources for quotes or jokes
get_sources <- function() {
  c("brainy", "statquotes", "dadjoke")
}

#' Main function to get a random quote.
#' By default a source is chosen randomly with random topic.
#' @export
quotes <- function(source = NULL, topic = NULL) {

  str_list_print <- function(vec) sub(",\\s+([^,]+)$", " and \\1", toString(vec))

  if(!is.null(source) && !source %in% get_sources())
    stop("Source ", source, " is not supported. ",
         "The supported sources are: ", str_list_print(get_sources()),
         ".")

  if(is.null(source)) source <- sample(get_sources(), 1)
  aquote <- switch(source,
         brainy     = bq_get_quote(topic = topic),
         statquotes = sq_get_quote(topic = topic),
         dadjoke    = dj_get_joke())

  aquote
}


#' Decorate a quote
#' @export
decorate <- function(quote,
                     decorator = paste(rep("-", 40), collapse=""),
                     width = 0.9 * getOption("width")) {
  cat(crayon::silver(decorator),
      strwrap(crayon::yellow(quote$text), width = width),
      crayon::italic$green(paste("         --", quote$source)),
      crayon::silver(decorator), sep = "\n")
}


