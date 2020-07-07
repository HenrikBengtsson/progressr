#' Creates and Signals a Progression Condition
#'
#' @param \ldots Arguments pass to [progression()].
#'
#' @param call (expression) A call expression.
#'
#' @return A [base::condition] of class `progression`.
#'
#' @seealso
#' To signal a progression condition, use [base::signalCondition()].
#' To create and signal a progression condition at once, use [progress()].
#'
#' @keywords internal
#' @export
progress <- function(..., call = sys.call()) {
  args <- list(...)
  if (length(args) == 1L && inherits(args[[1L]], "condition")) {
    cond <- args[[1L]]
    stop_if_not(inherits(cond, "progression"))
  } else {
    cond <- progression(..., call = call)
  }
  
  withRestarts(
    signalCondition(cond),
    muffleProgression = function(p) NULL
  )
  
  invisible(cond)
}
