#' Create a Progressor Function
#'
#' @param steps (integer) Maximum number of steps.
#'
#' @param label (character) A label.
#'
#' @param setup (logical) If TRUE, the progressor will signal a
#' [progression] 'setup' condition.
#'
#' @param auto_done (logical) If TRUE, then the progressor will signal a
#' [progression] 'done' condition as soon as the last step has been reached.
#'
#' @return A function of class `progressor`.
#'
#' @export
progressor <- function(steps, label = NA_character_, setup = TRUE, auto_done = TRUE) {
  label <- as.character(label)
  stop_if_not(length(label) == 1L)
  
  fcn <- function(..., type = "update") {
    progress(type = type, ...)
  }
  class(fcn) <- c("progressor", class(fcn))

  if (setup) fcn(type = "setup", steps = steps, auto_done = auto_done)
  
  fcn
}
