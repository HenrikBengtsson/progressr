#' Progression Handler: Progress Reported as a MS Windows Progress Bars in the GUI
#'
#' A progression handler for `winProgressBar()` in the \pkg{utils} package.
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires MS Windows.
#'
#' @export
handler_winprogressbar <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)
  
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("handler_winprogressbar")) {
    if (.Platform$OS.type != "windows") {
      stop("handler_winprogressbar requires MS Windows: ",
           sQuote(.Platform$OS.type))
    }
    ## Import functions
    winProgressBar <- utils::winProgressBar
    setWinProgressBar <- utils::setWinProgressBar
  } else {
    winProgressBar <- function(...) rawConnection(raw(0L))
    setWinProgressBar <- function(...) NULL
  }
  
  reporter <- local({
    pb <- NULL
    
    make_pb <- function(..., label = NULL) {
      if (!is.null(pb)) return(pb)
      label <- paste0(label, "")
      args <- c(list(..., label = label), backend_args)
      pb <<- do.call(winProgressBar, args = args)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, label = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = state$message)
        setWinProgressBar(pb, value = state$step, label = paste0(state$message, ""))
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setWinProgressBar(pb, value = state$step, label = paste0(state$message, ""))
        }
      }
    )
  })
  
  make_progression_handler("winprogressbar", reporter, intrusiveness = intrusiveness, target = target, ...)
}
