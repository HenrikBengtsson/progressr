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
#' @param sticky If TRUE, then a "sticky" message is outputted every
#' ten element.
#'
#' @return The sum of all elements in `x`.
#'
#' @section Progress updates:
#' This function signals [progression] conditions as it progresses.
#'
#' @keywords internal
#' @export
slow_sum <- function(x, delay = getOption("progressr.demo.delay", 1.0), stdout = FALSE, message = TRUE, sticky = TRUE) {
  p <- progressor(along = x)

  sum <- 0
  for (kk in seq_along(x)) {
    p(amount = 0)   ## "I'm alive" progression update
    Sys.sleep(0.2*delay)
    if (stdout) cat(sprintf("O: Element #%d\n", kk))
    Sys.sleep(0.2*delay)
    p(amount = 0)
    Sys.sleep(0.2*delay)
    sum <- sum + x[kk]
    p(message = sprintf("P: Adding %g", kk))
    Sys.sleep(0.2*delay)
    if (message) message(sprintf("M: Added value %g", x[kk]))
    p(amount = 0)
    Sys.sleep(0.2*delay)
    if (sticky && kk %% 10 == 0) {
      p(
        amount = 0,
        message = sprintf("P: %d elements done", kk),
        class = "sticky"
      )
    }
  }

  p(amount = 0)

  sum
}
