#' Progression Handler: Progress Reported as a Tcl/Tk Progress Bars in the GUI
#'
#' A progression handler for [tcltk::tkProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_tkprogressbar.R
#'
#' @section Requirements:
#' This progression handler requires the \pkg{tcltk} package and that the
#' current R session supports Tcl/Tk (`capabilities("tcltk")`).
#'
#' @export
handler_tkprogressbar <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)
  
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("handler_tkprogressbar")) {
    if (!capabilities("tcltk")) {
      stop("handler_tkprogressbar requires TclTk support")
    }
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar
  } else {
    tkProgressBar <- function(...) rawConnection(raw(0L))
    setTkProgressBar <- function(...) NULL
  }
  
  reporter <- local({
    pb <- NULL
    
    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      args <- c(list(...), backend_args)
      pb <<- do.call(tkProgressBar, args = args)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        ## NOTE: 'pb' may be re-used for tkProgressBar:s
        if (config$clear) stop_if_not(is.null(pb))
        make_pb(max = config$max_steps, label = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = state$message)
        setTkProgressBar(pb, value = state$step, label = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setTkProgressBar(pb, value = state$step, label = state$message)
        }
      }
    )
  })
  
  make_progression_handler("tkprogressbar", reporter, intrusiveness = intrusiveness, target = target, ...)
}
