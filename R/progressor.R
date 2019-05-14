#' Create a Progressor Function
#'
#' @param steps (integer) Maximum number of steps.
#'
#' @param label (character) A label.
#'
#' @param initiate (logical) If TRUE, the progressor will signal a
#' [progression] 'initiate' condition.
#'
#' @param auto_finish (logical) If TRUE, then the progressor will signal a
#' [progression] 'finish' condition as soon as the last step has been reached.
#'
#' @return A function of class `progressor`.
#'
#' @export
progressor <- function(steps, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
  label <- as.character(label)
  stop_if_not(length(label) == 1L)
  
  fcn <- function(..., type = "update") {
    progress(type = type, ...)
  }
  class(fcn) <- c("progressor", class(fcn))

  if (initiate) fcn(type = "initiate", steps = steps, auto_finish = auto_finish)
  
  fcn
}
