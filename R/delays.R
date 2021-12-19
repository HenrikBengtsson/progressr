use_delays <- function(handlers, terminal = NULL, stdout = NULL, conditions = NULL) {
  ## Do we need to buffer terminal output?
  if (is.null(terminal)) {
    delay <- vapply(handlers, FUN = function(h) {
      env <- environment(h)
      any(env$target == "terminal")
    }, FUN.VALUE = NA)
    terminal <- any(delay, na.rm = TRUE)
    
    ## If buffering output, does all handlers support intermediate flushing?
    if (terminal) {
      flush <- vapply(handlers, FUN = function(h) {
        env <- environment(h)
        if (!any(env$target == "terminal")) return(TRUE)
        !inherits(env$reporter$hide, "null_function")
      }, FUN.VALUE = NA)
      attr(terminal, "flush") <- all(flush, na.rm = TRUE)
    }
  }

  if (is.null(stdout)) {
    stdout <- getOption("progressr.delay_stdout", terminal)
  }

  if (is.null(conditions)) {
    conditions <- getOption("progressr.delay_conditions", {
      if (terminal) c("condition") else character(0L)
    })
  }

  list(terminal = terminal, stdout = stdout, conditions = conditions)
}


delay_stdout <- function(delays, stdout_file) {
  ## Delay standard output?
  if (is.null(stdout_file) && delays$stdout) {
    stdout_file <- buffer_stdout()
  }
  stdout_file
}
