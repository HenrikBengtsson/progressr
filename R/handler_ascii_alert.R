#' Progression Handler: Progress Reported as ASCII BEL Symbols (Audio or Blink) in the Terminal
#'
#' A progression handler based on `cat("\a", file=stderr())`.
#'
#' @inheritParams make_progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII BEL character (`'\a'` = `'\007'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_ascii_alert.R
#'
#' @export
handler_ascii_alert <- function(symbol = "\a", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.auditory", 5.0), target = c("terminal", "audio"), ...) {
  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        if (state$enabled && progression$amount != 0) cat(file = file, symbol)
      }
    )
  })

  make_progression_handler("ascii_alert", reporter, intrusiveness = intrusiveness, ...)
}
