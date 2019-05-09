#' Slowly Calculate Sum of Elements
#'
#' @param x Numeric vector to sum
#'
#' @param delay Delay in seconds after each addition.
#'
#' @return The sum of all elements in `x`.
#'
#' @section Progress updates:
#' This function signals [progression] conditions as it progresses.
#'
#' @export
slow_sum <- function(x, delay = getOption("delay", 0.05)) {
##  progress <- new_progress(length(x))
  progress <- progressor(steps = length(x), auto_done = TRUE)
  
  res <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(delay)
    res <- res + x[kk]
    progress()
  }
  
  res
}
