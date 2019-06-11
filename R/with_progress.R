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
#' @param delay_stdout If TRUE, standard output is captured and relayed
#' at the end just before any captured conditions are relayed.
#'
#' @param delay_conditions A character vector specifying [base::condition]
#' classes to be captured and relayed at the end after any captured
#' standard output is relayed.
#'
#' @return Return nothing (reserved for future usage).
#'
#' @example incl/with_progress.R
#'
#' @export
with_progress <- function(expr, handlers = getOption("progressr.handlers", txtprogressbar_handler()), cleanup = TRUE, delay_stdout = getOption("progressr.delay_stdout", interactive()), delay_conditions = getOption("progressr.delay_conditions", if (interactive()) c("condition") else character(0L))) {
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

  ## Captured stdout output and conditions
  stdout_file <- NULL
  conditions <- list()
  if (delay_stdout || length(delay_conditions) > 0) {
    ## Delay standard output?
    if (delay_stdout) {
      stdout_file <- rawConnection(raw(0L), open = "w")
      sink(stdout_file, type = "output", split = FALSE)
      on.exit({
        sink(type = "output", split = FALSE)
        stdout <- rawToChar(rawConnectionValue(stdout_file))
        close(stdout_file)
        if (length(stdout) > 0) cat(stdout, file = stdout())
      })
    }
    
    ## Delay conditions?
    if (length(delay_conditions) > 0) {
      on.exit({
        if (length(conditions) > 0L) {
          for (kk in seq_along(conditions)) {
            c <- conditions[[kk]]
            if (inherits(c, "message")) {
              message(c)
            } else if (inherits(c, "warning")) {
              warning(c)
            } else if (inherits(c, "condition")) {
              signalCondition(c)
            }
          }
        }
      }, add = TRUE)
    }
  } ## if (delay_stdout || length(delay_conditions) > 0)

  ## Reset all handlers up start
  withCallingHandlers({
      withRestarts({
        signalCondition(control_progression("reset"))
      }, muffleProgression = function(p) NULL)
  }, progression = handler)

  ## Evaluate expression
  withCallingHandlers(
    expr,
    progression = handler,
    condition = function(c) {
      if (inherits(c, c("progression", "error"))) return()
      if (inherits(c, delay_conditions)) {
        ## Record
        conditions[[length(conditions) + 1L]] <<- c
        ## Muffle
        if (inherits(c, "message")) {
          invokeRestart("muffleMessage")
        } else if (inherits(c, "warning")) {
          invokeRestart("muffleWarning")
        } else if (inherits(c, "condition")) {
          ## If there is a "muffle" restart for this condition,
          ## then invoke that restart, i.e. "muffle" the condition
          restarts <- computeRestarts(c)
          for (restart in restarts) {
            name <- restart$name
            if (is.null(name)) next
            if (!grepl("^muffle", name)) next
            invokeRestart(restart)
            break
          }
        }
      }
    }
  )
  
  ## Success
  status <- "ok"
  
  invisible(NULL)
}



control_progression <- function(type = "shutdown", ...) {
  progression(type = type, ..., class = "control_progression")  
}
