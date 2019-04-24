#' Evaluate Expression while Handling Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @param handlers A progression handler or a list of them.
#' If @NULL or an empty list, progress updates are ignored.
#'
#' @example incl/with_progress.R
#'
#' @export
with_progress <- function(expr, handlers = getOption("progressr.handlers", txtprogressbar_handler())) {
  if (length(handlers) == 0L) return(expr)
  if (!is.list(handlers)) handlers <- list(handlers)
  
  for (kk in seq_along(handlers)) {
    handler <- handlers[[kk]]
    stopifnot(is.function(handler))
    if (!inherits(handler, "progression_handler")) {
      handler <- handler()
      stopifnot(is.function(handler))
      handlers[[kk]] <- handler
    }
  }

  if (length(handlers) > 1L) {
    handler <- function(p) {
      for (kk in seq_along(handlers)) {
        handler <- handlers[[kk]]
        handler(p)
      }
    }
  } else {
    handler <- handlers[[1]]
  }
  
  withCallingHandlers(expr, progression = handler)
}
