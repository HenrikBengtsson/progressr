#' @details
#' `without_progress()` evaluates an expression while ignoring all
#' progress updates.
#'
#' @rdname with_progress
#' @export
without_progress <- function(expr) {
  withCallingHandlers(expr, progression = function(p) {
    invokeRestart("muffleProgression")
  })
  
  invisible(NULL)
}
