#' Progression Handler: Progress Reported as a New Line (Text) in the Terminal
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
#' @keywords internal
#' @export
handler_newline <- function(symbol = "\n", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", ...) {
  reporter <- local({
    list(
      hide     = function(...) NULL,
      unhide   = function(...) NULL,
      interrupt = function(config, state, progression, ...) {
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat(msg, file = file)
      },
      initiate = function(...) cat(file = file, symbol),
      update   = function(...) cat(file = file, symbol),
      finish   = function(...) cat(file = file, symbol)
    )
  })
  
  make_progression_handler("newline", reporter, intrusiveness = intrusiveness, target = target, ...)
}
