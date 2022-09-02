#' Control How Progress is Reported
#'
#' @param \dots One or more progression handlers.  Alternatively, this
#' functions accepts also a single vector of progression handlers as input.
#' If this vector is empty, then an empty set of progression handlers will
#' be set.
#'
#' @param append (logical) If FALSE, the specified progression handlers
#' replace the current ones, otherwise appended to them.
#'
#' @param on_missing (character) If `"error"`, an error is thrown if one of
#' the progression handlers does not exists.  If `"warning"`, a warning
#' is produces and the missing handlers is ignored.  If `"ignore"`, the
#' missing handlers is ignored.
#'
#' @param default The default progression calling handler to use if none
#' are set.
#'
#' @param global If TRUE, then the global progression handler is enabled.
#' If FALSE, it is disabled.  If NA, then TRUE is returned if it is enabled,
#' otherwise FALSE.  Argument `global` must not used with other arguments.
#'
#' @return (invisibly) the previous list of progression handlers set.
#' If no arguments are specified, then the current set of progression
#' handlers is returned.
#' If `global` is specified, then TRUE is returned if the global progression
#' handlers is enabled, otherwise false.
#'
#' @details
#' This function provides a convenient alternative for getting and setting
#' option \option{progressr.handlers}.
#'
#' @section For package developers:
#' **IMPORTANT: Setting progression handlers is a privilege that should be
#' left to the end user. It should not be used by R packages, which only task
#' is to _signal_ progress updates, not to decide if, when, and how progress
#' should be reported.**
#'
#' If you have to set or modify the progression handlers inside a function,
#' please make sure to undo the settings afterward.  If not, you will break
#' whatever progression settings the user already has for other purposes
#' used elsewhere.  To undo you settings, you can do:
#'
#' ```r
#' old_handlers <- handlers(c("beepr", "progress"))
#' on.exit(handlers(old_handlers), add = TRUE)
#' ```
#'
#' @section Configuring progression handling during R startup:
#' A convenient place to configure the default progression handler and to
#' enable global progression reporting by default is in the \file{~/.Rprofile}
#' startup file.  For example, the following will (i) cause your interactive
#' R session to use global progression handler by default, and (ii) report
#' progress via the \pkg{progress} package when in the terminal and via the
#' RStudio Jobs progress bar when in the RStudio Console.
#' [handler_txtprogressbar], 
#' other whenever using the RStudio Console, add
#' the following to your \file{~/.Rprofile} startup file:
#'
#' ```r
#' if (interactive() && requireNamespace("progressr", quietly = TRUE)) {
#'   ## Enable global progression updates
#'   if (getRversion() >= 4) progressr::handlers(global = TRUE)
#'
#'   ## In RStudio Console, or not?
#'   if (Sys.getenv("RSTUDIO") == "1" && !nzchar(Sys.getenv("RSTUDIO_TERM"))) {
#'     options(progressr.handlers = progressr::handler_rstudio)
#'   } else {
#'     options(progressr.handlers = progressr::handler_progress)
#'   }
#' }
#' ```
#'
#' @example incl/handlers.R
#'
#' @export
handlers <- function(..., append = FALSE, on_missing = c("error", "warning", "ignore"), default = handler_txtprogressbar, global = NULL) {
  stop_if_not(
    is.null(global) ||
    ( is.logical(global) && length(global) == 1L )
  )
  args <- list(...)
  nargs <- length(args)

  if (nargs == 0L) {
    ## Get the current set of progression handlers?
    if (is.null(global)) {
      if (!is.list(default) && !is.null(default)) default <- list(default)
      return(getOption("progressr.handlers", default))
    }

    ## Check, register, or reset global calling handlers?
    if (is.na(global)) {
      return(register_global_progression_handler(action = "query"))
    }
    action <- if (isTRUE(global)) "add" else "remove"
    return(invisible(register_global_progression_handler(action = action)))
  }

  if (!is.null(global)) {
    stop("Argument 'global' must not be specified when also registering progress handlers")
  }

  on_missing <- match.arg(on_missing)
  
  ## Was a list specified?
  if (nargs == 1L && is.vector(args[[1]])) {
    args <- args[[1]]
  }

  handlers <- list()
  names <- names(args)
  for (kk in seq_along(args)) {
    handler <- args[[kk]]
    stop_if_not(length(handler) == 1L)
    
    if (is.character(handler)) {
      name <- handler
      name2 <- sprintf("handler_%s", name)
      
      handler <- NULL
      if (exists(name2, mode = "function")) {
        handler <- get(name2, mode = "function")
      }
      
      if (is.null(handler)) {
        if (exists(name, mode = "function")) {
          handler <- get(name, mode = "function")
        }
      }
      
      if (is.null(handler)) {
        if (on_missing == "error") {
          stop("No such progression handler found: ", sQuote(name))
	} else if (on_missing == "warning") {
          warning("Ignoring non-existing progression handler: ", sQuote(name))
	}
        next
      }

      names[kk] <- name
    }
    stop_if_not(is.function(handler), length(formals(handler)) >= 1L)
    handlers[[kk]] <- handler
  }
  stop_if_not(is.list(handlers))
  names(handlers) <- names

  ## Drop non-existing handlers
  keep <- vapply(handlers, FUN = is.function, FUN.VALUE = FALSE)
  handlers <- handlers[keep]

  if (append) {
    current <- getOption("progressr.handlers", list())
    if (length(current) > 0L) handlers <- c(current, handlers)
  }

  invisible(options(progressr.handlers = handlers)[[1]])
}
