#' A Progression Condition
#'
#' A progression condition represents a progress in an \R program.
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
#' @param type Type of progression made.
#'
#' @param class (character) Zero or more class names to prepend.
#'
#' @param progressor_uuid (character string) A character string that is unique
#' for the current progressor and the current \R session.
#'
#' @param progression_index (integer) A non-negative integer that is
#' incremented by one for each progression condition created.
#'
#' @param progression_time (POSIXct or character string) A timestamp specifying
#' when the progression condition was created.
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
#' @keywords internal
#' @export
progression <- function(message = character(0L), amount = 1.0, step = NULL, time = progression_time, ..., type = "update", class = NULL, progressor_uuid = NULL, progression_index = NULL, progression_time = Sys.time(), call = NULL, owner_session_uuid = NULL) {
  message <- as.character(message)
  amount <- as.numeric(amount)
  time <- as.POSIXct(time)
  stop_if_not(is.character(type), length(type) == 1L, !is.na(type))
  class <- as.character(class)
  if (inherits(progression_time, "POSIXct")) {
    progression_time <- format(progression_time, format = "%F %H:%M:%OS3 %z")
  }
  stop_if_not(length(progression_time) == 1L, is.character(progression_time))
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
      progression_time = progression_time,
      type = type,
      message = message,
      amount = amount,
      step = step,
      time = time,
      ...,
      call = call
    ),
    class = c(class, "progression", "immediateCondition", "condition")
  )
}



#' @export
print.progression <- function(x, ...) {
  s <- sprintf("%s:", class(x)[1])
  s <- c(s, paste("- call:", deparse(conditionCall(x))))
  s <- c(s, paste("- type:", x$type))
  s <- c(s, paste("- message:", sQuote(conditionMessage(x))))
  s <- c(s, paste("- amount:", x$amount))
  s <- c(s, paste("- step:", x$step))
  s <- c(s, paste("- time:", x$time))
  s <- c(s, paste("- progressor_uuid:", x$progressor_uuid))
  s <- c(s, paste("- progression_index:", x$progression_index))
  s <- c(s, paste("- progression_time:", x$progression_time))
  s <- c(s, paste("- session_uuid:", x$session_uuid))
  s <- c(s, paste("- owner_session_uuid:", x$owner_session_uuid))
  s <- c(s, paste("- classes:", paste(sQuote(class(x)), collapse = ", ")))
  s <- paste(s, collapse = "\n")
  cat(s, "\n", sep = "")
  
  invisible(x)
}
