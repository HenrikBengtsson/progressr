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
      globalCallingHandlers(progression = global_progression_handler)
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
  genv <- globalenv()
  
  update_calling_handler <- function() {
    handlers <- handlers()
    # Nothing to do?
    if (length(handlers) == 0L) return(NULL)

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

    ## Keep only enabled handlers
    enabled <- vapply(handlers, FUN = function(h) {
      env <- environment(h)
      value <- env$enable
      isTRUE(value) || is.null(value)
    }, FUN.VALUE = TRUE)
    handlers <- handlers[enabled]

    # Nothing to do?
    if (length(handlers) == 0L) return(NULL)

    if (length(handlers) > 1L) {
      calling_handler <<- function(p) {
        finished <- rep(NA, times = length(handlers))
        for (kk in seq_along(handlers)) {
          handler <- handlers[[kk]]
          finished[kk] <- handler(p)
        }
        stop_if_not(all(finished == finished[1]))
        finished[1]
      }
    } else {
      calling_handler <<- handlers[[1]]
    }
  }

  function(progression) {
    ## To please R CMD check
    calling_handler <- NULL; rm(list = "calling_handler")
    
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
          finished <- calling_handler(progression)
          if (debug) message(" - finished: ", finished)
        }
        current_progressor_uuid <<- NULL
        calling_handler <<- NULL
      }
    }
    if (debug) message(" - done")

    return()
  }
}) ## global_progression_handler()



if (getRversion() < "4.0.0") {
  globalCallingHandlers <- function(...) {
    stop("register_global_progression_handler() requires R (>= 4.0.0)")
  }
}
