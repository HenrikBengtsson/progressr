#' Evaluate Expression while Ignoring All Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @export
without_progress <- function(expr) {
  withCallingHandlers(expr, progression = function(p) {
    invokeRestart("muffleProgression")
  })
}
