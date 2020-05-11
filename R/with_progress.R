#' Report on Progress while Evaluating an R Expression
#'
#' @param expr An \R expression to evaluate.
#'
#' @param handlers A progression handler or a list of them.
#' If NULL or an empty list, progress updates are ignored.
#'
#' @param cleanup If TRUE, all progression handlers will be shutdown
#' at the end regardless of the progression is complete or not.
#'
#' @param delay_terminal If TRUE, output and conditions that may end up in
#' the terminal will delayed.
#'
#' @param delay_stdout If TRUE, standard output is captured and relayed
#' at the end just before any captured conditions are relayed.
#'
#' @param delay_conditions A character vector specifying [base::condition]
#' classes to be captured and relayed at the end after any captured
#' standard output is relayed.
#'
#' @param interval (numeric) The minimum time (in seconds) between
#' successive progression updates from handlers.
#'
#' @param enable (logical) If FALSE, then progress is not reported.  The
#' default is to report progress in interactive mode but not batch mode.
#' See below for more details.
#'
#' @return Return nothing (reserved for future usage).
#'
#' @example incl/with_progress.R
#'
#' @details
#' _IMPORTANT: This function is meant for end users only.  It should not
#' be used by R packages, which only task is to _signal_ progress updates,
#' not to decide if, when, and how progress should be reported._
#'
#' @section Progression handler functions:
#' Formally, progression handlers are calling handlers that are called
#' when a [progression] condition is signaled.  These handlers are functions
#' that takes one argument which is the [progression] condition.
#'
#' @section Progress updates in batch mode:
#' When running R from the command line, R runs in a non-interactive mode
#' (`interactive()` returns `FALSE`).  The default behavior of
#' `with_progress()` is to _not_ report on progress in non-interactive mode.
#' To have progress being reported on also then, set R options
#' \option{progressr.enable} or environment variable \env{R_PROGRESSR_ENABLE}
#' to `TRUE`.  Alternatively, one can set argument `enable=TRUE` when calling
#' `with_progress()`.  For example,
#' ```sh
#' $ Rscript -e "library(progressr)" -e "with_progress(slow_sum(1:5))"
#' ```
#' will _not_ report on progress, whereas:
#' ```sh
#' $ export R_PROGRESSR_ENABLE=TRUE
#' $ Rscript -e "library(progressr)" -e "with_progress(slow_sum(1:5))"
#' ```
#' will.
#'
#' @seealso
#' [base::withCallingHandlers()]
#'
#' @export
with_progress <- function(expr, handlers = progressr::handlers(), cleanup = TRUE, delay_terminal = NULL, delay_stdout = NULL, delay_conditions = NULL, interval = NULL, enable = NULL) {
  buffer_stdout <- function() {
    stdout_file <- rawConnection(raw(0L), open = "w")
    sink(stdout_file, type = "output", split = FALSE)
    stdout_file
  } ## buffer_stdout()
  
  flush_stdout <- function(stdout_file, close = TRUE) {
    if (is.null(stdout_file)) return(NULL)
    sink(type = "output", split = FALSE)
    stdout <- rawToChar(rawConnectionValue(stdout_file))
    if (length(stdout) > 0) cat(stdout, file = stdout())
    close(stdout_file)
    stdout_file <- NULL
    if (!close) stdout_file <- buffer_stdout()
    stdout_file
  } ## flush_stdout()

  has_buffered_stdout <- function(stdout_file) {
    !is.null(stdout_file) && (length(rawConnectionValue(stdout_file)) > 0L)
  }

  flush_conditions <- function(conditions) {
    for (c in conditions) {
      if (inherits(c, "message")) {
        message(c)
      } else if (inherits(c, "warning")) {
        warning(c)
      } else if (inherits(c, "condition")) {
        signalCondition(c)
      }
    }
    list()
  } ## flush_conditions()
 
  stop_if_not(is.logical(cleanup), length(cleanup) == 1L, !is.na(cleanup))
  
  ## FIXME: With zero handlers, progression conditions will be
  ##        passed on upstream just as without with_progress().
  ##        Is that what we want? /HB 2019-05-17

  # Nothing to do?
  if (length(handlers) == 0L) return(expr)

  ## Temporarily set progressr options
  options <- list()
  if (!is.null(interval)) {
    stop_if_not(is.numeric(interval), length(interval) == 1L, !is.na(interval))
    options[["progressr.interval"]] <- interval
  }
  
  if (length(options) > 0L) {  
    oopts <- options(options)
    on.exit(options(oopts))
  }

  ## Enabled or not?
  if (!is.null(enable)) {
    stop_if_not(is.logical(enable), length(enable) == 1L, !is.na(enable))
    
    # Nothing to do?
    if (!enable) return(expr)

    options[["progressr.enable"]] <- enable
  }

  if (!is.list(handlers)) handlers <- list(handlers)

  for (kk in seq_along(handlers)) {
    handler <- handlers[[kk]]
    stopifnot(is.function(handler))
    if (!inherits(handler, "progression_handler")) {
      handler <- handler()
      stopifnot(is.function(handler), inherits(handler, "progression_handler"))
      handlers[[kk]] <- handler
    }
  }

  ## Keep only enabled handlers
  enabled <- vapply(handlers, FUN = function(h) {
    env <- environment(h)
    value <- env$enable
    isTRUE(value) || is.null(value)
  }, FUN.VALUE = TRUE)
  handlers <- handlers[enabled]
  
  ## Nothing to do?
  if (length(handlers) == 0L) return(expr)


  ## Do we need to buffer terminal output?
  if (is.null(delay_terminal)) {
    delay_terminal <- vapply(handlers, FUN = function(h) {
      env <- environment(h)
      any(env$target == "terminal")
    }, FUN.VALUE = NA)
    delay_terminal <- any(delay_terminal, na.rm = TRUE)
  }
  
  if (is.null(delay_stdout)) {
    delay_stdout <- getOption("progressr.delay_stdout", delay_terminal)
  }

  if (is.null(delay_conditions)) {
    delay_conditions <- getOption("progressr.delay_conditions", {
      if (delay_terminal) c("condition") else character(0L)
    })
  }

  ## If buffering output, does all handlers support intermediate flushing?
  flush_terminal <- FALSE 
  if (delay_terminal) {
    flush_terminal <- vapply(handlers, FUN = function(h) {
      env <- environment(h)
      if (!any(env$target == "terminal")) return(TRUE)
      !inherits(env$reporter$hide, "null_function")
    }, FUN.VALUE = NA)
    flush_terminal <- all(flush_terminal, na.rm = TRUE)
  }

  if (length(handlers) > 1L) {
    calling_handler <- function(p) {
      for (kk in seq_along(handlers)) {
        handler <- handlers[[kk]]
        handler(p)
      }
    }
  } else {
    calling_handler <- handlers[[1]]
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
      }, progression = calling_handler)
    }, add = TRUE)
  }

  ## Delay standard output?
  if (delay_stdout) {
    stdout_file <- buffer_stdout()
    on.exit(flush_stdout(stdout_file), add = TRUE)
  } else {
    stdout_file <- NULL
  }
  
  ## Delay conditions?
  conditions <- list()
  if (length(delay_conditions) > 0) {
    on.exit(flush_conditions(conditions), add = TRUE)
  }

  ## Reset all handlers up start
  withCallingHandlers({
    withRestarts({
      signalCondition(control_progression("reset"))
    }, muffleProgression = function(p) NULL)
  }, progression = calling_handler)

  ## Evaluate expression
  capture_conditions <- TRUE
  withCallingHandlers(
    expr,
    progression = function(p) {
      ## Don't capture conditions that are produced by progression handlers
      capture_conditions <<- FALSE
      on.exit(capture_conditions <<- TRUE)

      ## Any buffered output to flush?
      if (flush_terminal) {
        if (length(conditions) > 0L || has_buffered_stdout(stdout_file)) {
          calling_handler(control_progression("hide"))
          stdout_file <<- flush_stdout(stdout_file, close = FALSE)
          conditions <<- flush_conditions(conditions)
          calling_handler(control_progression("unhide"))
        }
      }
      
      calling_handler(p)
    },
    condition = function(c) {
      if (!capture_conditions || inherits(c, c("progression", "error"))) return()
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
