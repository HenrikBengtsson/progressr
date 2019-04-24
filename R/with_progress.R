#' Evaluate Expression while Handling Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @param renderer (function) A progression renderer.
#' If @NULL, progress updates are ignored.
#'
#' @export
with_progress <- function(expr, renderer = renderer_txtprogressbar()) {
  if (is.null(renderer)) return(expr)
  stopifnot(is.function(renderer))
  if (!inherits(renderer, "progression_renderer")) {
    renderer <- renderer()
    stopifnot(is.function(renderer))
  }
  withCallingHandlers(expr, progression = renderer)
}
