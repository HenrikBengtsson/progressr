#' Evaluate Expression while Ignoring All Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @return Return nothing (reserved for future usage).
#'
#' @export
without_progress <- function(expr) {
  withCallingHandlers(expr, progression = function(p) {
    invokeRestart("muffleProgression")
  })
  
  invisible(NULL)
}
