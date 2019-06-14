#' Slowly Calculate Sum of Elements
#'
#' @param x Numeric vector to sum
#'
#' @param delay Delay in seconds after each addition.
#'
#' @param stdout If TRUE, then a text is outputted to the standard output
#' per element.
#'
#' @param message If TRUE, then a message is outputted per element.
#'
#' @return The sum of all elements in `x`.
#'
#' @section Progress updates:
#' This function signals [progression] conditions as it progresses.
#'
#' @export
slow_sum <- function(x, delay = getOption("delay", 0.05), stdout = FALSE, message = FALSE) {
  progress <- progressor(length(x))

  sum <- 0
  for (kk in seq_along(x)) {
    if (stdout) cat(sprintf("O: Element #%d\n", kk))
    Sys.sleep(delay)
    sum <- sum + x[kk]
    progress(message = sprintf("P: Adding %g", kk))
    if (message) message(sprintf("M: Added value %g", x[kk]))
  }

  sum
}
