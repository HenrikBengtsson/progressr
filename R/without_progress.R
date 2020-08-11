#' @details
#' `without_progress()` evaluates an expression while ignoring all
#' progress updates.
#'
#' @rdname with_progress
#' @export
without_progress <- function(expr) {
  res <- withCallingHandlers(
    withVisible(expr),
    progression = function(p) {
      invokeRestart("muffleProgression")
    }
  )

  if (res$visible) {
    res$value
  } else {
    invisible(res$value)
  }
}
