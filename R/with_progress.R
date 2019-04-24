#' Evaluate Expression while Handling Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @param handler (function) A progression handler.
#' If @NULL, progress updates are ignored.
#'
#' @example incl/with_progress.R
#'
#' @export
with_progress <- function(expr, handler = getOption("progressr.handler", txtprogressbar_handler())) {
  if (is.null(handler)) return(expr)
  stopifnot(is.function(handler))
  if (!inherits(handler, "progression_handler")) {
    handler <- handler()
    stopifnot(is.function(handler))
  }
  withCallingHandlers(expr, progression = handler)
}
