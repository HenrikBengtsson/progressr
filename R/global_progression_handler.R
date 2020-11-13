#' Add or Remove a Global 'progression' Handler
#'
#' @param action (character string)
#' If `"add"`, a global handler is added.
#' If `"remove"`, it is removed, if it exists.
#' If `"query"`, checks whether a handler is registered or not.
#'
#' @return Returns TRUE if a handler is registered, otherwise FALSE.
#' If `action = "query"`, the value is visible, otherwise invisible.
#'
#' @section Requirements:
#' This function requires R (>= 4.0.0) - the version in which global calling
#' handlers where introduces.
#'
#' @example incl/register_global_progression_handler.R
#'
#' @export
register_global_progression_handler <- function(action = c("add", "remove", "query")) {
  action <- match.arg(action)

  if (getRversion() < "4.0.0") {
    warning("register_global_progression_handler() requires R (>= 4.0.0)")
    return(invisible(FALSE))
  }

  ## All existing handlers
  handlers <- globalCallingHandlers()

  exists <- vapply(handlers, FUN = identical, global_progression_handler, FUN.VALUE = FALSE)
  if (sum(exists) > 1L) {
    warning("Detected more than one registered 'global_progression_handler'. Did you register it manually?")
  }
  
  if (action == "add") {
    if (!any(exists)) {
      globalCallingHandlers(condition = global_progression_handler)
    }
    invisible(TRUE)
  } else  if (action == "remove") {
    handlers <- handlers[!exists]
    ## Remove all
    globalCallingHandlers(NULL)
    ## Add back the ones we didn't drop
    globalCallingHandlers(handlers)
    invisible(FALSE)
  } else  if (action == "query") {
    any(exists)
  }
}


#' A Global Calling Handler For 'progression':s
#'
#' @param progression A [progression] conditions.
#'
#' @return Nothing.
#'
#' @section Requirements:
#' This function requires R (>= 4.0.0) - the version in which global calling
#' handlers where introduces.
#' 
#' @keywords internal
global_progression_handler <- local({
  current_progressor_uuid <- NULL
  calling_handler <- NULL
  delays <- NULL
  stdout_file <- NULL
  capture_conditions <- TRUE
  conditions <- list()
  genv <- globalenv()
  
  update_calling_handler <- function() {
    handlers <- handlers()
    # Nothing to do?
    if (length(handlers) == 0L) return(NULL)

    handlers <- as_progression_handler(handlers)

    # Nothing to do?
    if (length(handlers) == 0L) return(NULL)

    ## Do we need to buffer?
    delays <<- use_delays(handlers)

    calling_handler <<- make_calling_handler(handlers)
  }

  handle_progression <- function(progression) {
    ## To please R CMD check
    calling_handler <- NULL; rm(list = "calling_handler")

    ## Don't capture conditions that are produced by progression handlers
    capture_conditions <<- FALSE
    on.exit(capture_conditions <<- TRUE)

    stop_if_not(inherits(progression, "progression"))
    
    assign(".Last.progression", value = progression, envir = genv, inherits = FALSE)
  
    debug <- getOption("progressr.global.debug", FALSE)
    
    if (debug) message(sprintf("*** Caught a %s condition:", sQuote(class(progression)[1])))
    progressor_uuid <- progression[["progressor_uuid"]]
    if (debug) message(" - source: ", progressor_uuid)
    
    ## Listen to this progressor?
    if (!is.null(current_progressor_uuid) &&
        !identical(progressor_uuid, current_progressor_uuid)) {
      if (debug) message(" - action: ignoring, already listening to another")
      return()
    }


    if (!is.null(calling_handler) && !is.null(delays)) {
      ## Any buffered output to flush?
      if (isTRUE(attr(delays$terminal, "flush"))) {
        if (length(conditions) > 0L || has_buffered_stdout(stdout_file)) {
          calling_handler(control_progression("hide"))
          stdout_file <<- flush_stdout(stdout_file, close = FALSE)
          conditions <<- flush_conditions(conditions)
          calling_handler(control_progression("unhide"))
        }
      }
    }

    type <- progression[["type"]]
    if (debug) message(" - type: ", type)
  
    if (type == "initiate") {
      if (identical(progressor_uuid, current_progressor_uuid)) {
        stop(sprintf("INTERNAL ERROR: Already listening to this progressor which just sent another %s request", sQuote(type)))
      }
      if (debug) message(" - start listening")
      current_progressor_uuid <<- progressor_uuid
      if (debug) message(" - reset progression handlers")
      update_calling_handler()
      if (!is.null(calling_handler)) {      
        stdout_file <<- delay_stdout(delays, stdout_file = stdout_file)
        calling_handler(control_progression("reset"))
        if (debug) message(" - initiate progression handlers")
        finished <- calling_handler(progression)
        if (debug) message(" - finished: ", finished)
      }
    } else if (type == "update") {
      if (is.null(current_progressor_uuid)) {
        ## We might receive zero-amount progress updates after the fact that the
        ## progress has been completed
        amount <- progression$amount
        if (!is.numeric(amount) || amount > 0) {
          stop(sprintf("INTERNAL ERROR: Received an %s request but is not listening to this progressor", sQuote(type)))
        }
      }
      if (debug) message(" - update progression handlers")
      if (!is.null(calling_handler)) {
        stdout_file <<- delay_stdout(delays, stdout_file = stdout_file)
        finished <- calling_handler(progression)
        if (debug) message(" - finished: ", finished)
        if (finished) {
          calling_handler(control_progression("shutdown"))
          current_progressor_uuid <<- NULL
        }
      }
    } else if (type == "finish") {
      ## Already shutdown?  Do nothing
      if (!is.null(current_progressor_uuid)) {
        if (debug) message(" - shutdown progression handlers")
        if (!is.null(calling_handler)) {
          stdout_file <<- delay_stdout(delays, stdout_file = stdout_file)
          finished <- calling_handler(progression)
          stdout_file <<- flush_stdout(stdout_file, close = TRUE)
          conditions <<- flush_conditions(conditions)
          if (debug) message(" - finished: ", finished)
        }
        current_progressor_uuid <<- NULL
        calling_handler <<- NULL
        stop_if_not(is.null(stdout_file), length(conditions) == 0L)
      }
    }
    if (debug) message(" - done")

    return()
  } ## handle_progression()


  function(condition) {
    ## Nothing do to?
    if (!capture_conditions || inherits(condition, "error")) return()
    
    ## A 'progression' update?
    if (inherits(condition, "progression")) {
      return(handle_progression(condition))
    }

    ## Nothing more do to?
    if (is.null(delays) || !inherits(condition, delays$conditions)) return()

    ## Record non-progression condition to be flushed later
    conditions[[length(conditions) + 1L]] <<- condition
    
    ## Muffle it for now
    if (inherits(condition, "message")) {
      invokeRestart("muffleMessage")
    } else if (inherits(condition, "warning")) {
      invokeRestart("muffleWarning")
    } else if (inherits(condition, "condition")) {
      ## If there is a "muffle" restart for this condition,
      ## then invoke that restart, i.e. "muffle" the condition
      restarts <- computeRestarts(condition)
      for (restart in restarts) {
        name <- restart$name
        if (is.null(name)) next
        if (!grepl("^muffle", name)) next
        invokeRestart(restart)
        break
      }
    }
  }
}) ## global_progression_handler()



if (getRversion() < "4.0.0") {
  globalCallingHandlers <- function(...) {
    stop("register_global_progression_handler() requires R (>= 4.0.0)")
  }
}



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
 


as_progression_handler <- function(handlers, drop = TRUE) {
  ## FIXME(?)
  if (!is.list(handlers)) handlers <- list(handlers)
  
  for (kk in seq_along(handlers)) {
    handler <- handlers[[kk]]
    stop_if_not(is.function(handler))
    if (!inherits(handler, "progression_handler")) {
      handler <- handler()
      stop_if_not(is.function(handler),
                  inherits(handler, "progression_handler"))
      handlers[[kk]] <- handler
    }
  }

  ## Keep only enabled handlers?
  if (drop) {
    enabled <- vapply(handlers, FUN = function(h) {
      env <- environment(h)
      value <- env$enable
      isTRUE(value) || is.null(value)
    }, FUN.VALUE = TRUE)
    handlers <- handlers[enabled]
  }

  handlers
}



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


make_calling_handler <- function(handlers) {
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
  calling_handler
}
