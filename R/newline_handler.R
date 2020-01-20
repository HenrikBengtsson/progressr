#' Textual Progression Feedback that outputs a Newline
#'
#' @inheritParams make_progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII NL character (`'\n'` = `'\013'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @export
newline_handler <- function(symbol = "\n", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", ...) {
  reporter <- local({
    list(
      initiate = function(...) cat(file = file, symbol),
      update   = function(...) cat(file = file, symbol),
      finish   = function(...) cat(file = file, symbol)
    )
  })
  
  make_progression_handler("newline", reporter, intrusiveness = intrusiveness, ...)
}
