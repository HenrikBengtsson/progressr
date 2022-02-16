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


buffer_stdout <- function() {
  stdout_file <- rawConnection(raw(0L), open = "w")
  sink(stdout_file, type = "output", split = FALSE)
  attr(stdout_file, "sink_index") <- sink.number(type = "output")
  stdout_file
} ## buffer_stdout()


flush_stdout <- function(stdout_file, close = TRUE, must_work = FALSE) {
  if (is.null(stdout_file)) return(NULL)

  ## Can we close the sink we opened?
  ## It could be that a progressor completes while there is a surrounding
  ## sink active, e.g. an active capture.output(), or when signalled within
  ## a sequential future.  Because of this, we might not be able to flush
  ## close the sink here.
  sink_index <- attr(stdout_file, "sink_index")
  if (sink_index != sink.number("output")) {
    if (must_work) {
      stop(sprintf("[progressr] Cannot flush stdout because the current sink index (%d) is out of sync with the sink we want to close (%d)", sink.number("output"), sink_index))
    }
    return(stdout_file)
  }
  
  sink(split = FALSE, type = "output")
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
 