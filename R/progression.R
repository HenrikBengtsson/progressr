#' A Progression Condition
#'
#' @param message (character) A progress message.
#'
#' @param amount (numeric) The total amount of progress made.
#'
#' @param step (character or integer) The step completed.
#'
#' @param time (POSIXct) A timestamp.
#'
#' @param \ldots Additional named elements.
#'
#' @param class (character) Zero or more class names to prepend.
#'
#' @param call (expression) A call expression.
#'
#' @return A [base::condition] of class `progression`.
#'
#' @seealso
#' To signal a progression condition, use [base::signalCondition()].
#' To create and signal a progression condition at once, use [progress()].
#'
#' @export
progression <- function(message = character(0L), amount = 1.0, step = NULL, time = Sys.time(), ..., class = NULL, call = NULL) {
  message <- as.character(message)
  amount <- as.numeric(amount)
  time <- as.POSIXct(time)
  class <- as.character(class)
  args <- list(...)
  nargs <- length(args)
  if (nargs > 0L) {
    names <- names(args)
    stopifnot(!is.null(names), all(nzchar(names)),
              length(unique(names)) == nargs)
  }
  
  structure(
    list(
      message = message,
      amount = amount,
      step = step,
      time = time,
      ...,
      call = call
    ),
    class = c(class, "progression", "condition")
  )
}
