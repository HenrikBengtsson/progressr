#' Evaluate Expression while Handling Progress Updates
#'
#' @param expr An \R expression to evaluate.
#'
#' @param handlers A progression handler or a list of them.
#' If @NULL or an empty list, progress updates are ignored.
#'
#' @param cleanup If TRUE, all progression handlers will be shutdown
#' at the end regardless of the progression is complete or not.
#'
#' @return Return nothing (reserved for future usage).
#'
#' @example incl/with_progress.R
#'
#' @export
with_progress <- function(expr, handlers = getOption("progressr.handlers", txtprogressbar_handler()), cleanup = TRUE) {
  stop_if_not(is.logical(cleanup), length(cleanup) == 1L, !is.na(cleanup))
  
  ## FIXME: With zero handlers, progression conditions will be
  ##        passed on upstream just as without with_progress().
  ##        Is that what we want? /HB 2019-05-17
  if (length(handlers) == 0L) return(expr)
  if (!is.list(handlers)) handlers <- list(handlers)
  
  for (kk in seq_along(handlers)) {
    handler <- handlers[[kk]]
    stopifnot(is.function(handler))
    if (!inherits(handler, "progression_handler")) {
      handler <- handler()
      stopifnot(is.function(handler))
      handlers[[kk]] <- handler
    }
  }

  if (length(handlers) > 1L) {
    handler <- function(p) {
      for (kk in seq_along(handlers)) {
        handler <- handlers[[kk]]
        handler(p)
      }
    }
  } else {
    handler <- handlers[[1]]
  }

  ## Flag indicating whether with_progress() exited due to
  ## an error or not.
  status <- "incomplete"

  ## Tell all progression handlers to shutdown at the end and
  ## the status of the evaluation.
  if (cleanup) {
    on.exit({
      withCallingHandlers({
        withRestarts({
          signalCondition(control_progression("shutdown", status = status))
        }, muffleProgression = function(p) NULL)
      }, progression = handler)
    })
  }

  ## Reset all handlers up start
  withCallingHandlers({
    withRestarts({
      signalCondition(control_progression("reset"))
    }, muffleProgression = function(p) NULL)
  }, progression = handler)

  ## Evaluate expression
  withCallingHandlers(expr, progression = handler)

  ## Success
  status <- "ok"
  
  invisible(NULL)
}



control_progression <- function(type = "shutdown", ...) {
  progression(type = type, ..., class = "control_progression")  
}
