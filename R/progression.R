#' A Progression Condition
#'
#' @param amount (numeric) The total amount of progress made.
#'
#' @param message (character) A progress message.
#'
#' @param step (character or integer) The step completed.
#'
#' @param time (POSIXct) A timestamp.
#'
#' @param \ldots Additional named elements.
#'
#' @param type Type of progression made.
#'
#' @param class (character) Zero or more class names to prepend.
#'
#' @param progressor_uuid (character string) A character string that is unique
#' for the current progressor and the current \R session.
#'
#' @param progression_index (integer) A non-negative integer that is
#  incremented by one for each progression condition created.
#'
#' @param owner_session_uuid (character string) A character string that is
#' unique for the \R session where the progressor was created.
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
progression <- function(amount = 1.0, message = character(0L), step = NULL, time = Sys.time(), ..., type = "update", class = NULL, progressor_uuid = NULL, progression_index = NULL, call = NULL, owner_session_uuid = NULL) {
  message <- as.character(message)
  amount <- as.numeric(amount)
  time <- as.POSIXct(time)
  stop_if_not(is.character(type), length(type) == 1L, !is.na(type))
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
      owner_session_uuid = owner_session_uuid,
      progressor_uuid = progressor_uuid,
      session_uuid = session_uuid(),
      progression_index = progression_index,
      type = type,
      message = message,
      amount = amount,
      step = step,
      time = time,
      ...,
      call = call
    ),
    class = c(class, "progression", "instant_relay_condition", "condition")
  )
}
