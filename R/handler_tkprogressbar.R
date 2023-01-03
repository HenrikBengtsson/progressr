#' Progression Handler: Progress Reported as a Tcl/Tk Progress Bars in the GUI
#'
#' A progression handler for [tcltk::tkProgressBar()].
#'
#' @inheritParams make_progression_handler
#' @inheritParams handler_winprogressbar
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
handler_tkprogressbar <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "terminal", inputs = list(title = NULL, label = "message"), ...) {
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
    tkProgressBar <- function(title = "R progress bar", label = "", min = 0, max = 1, initial = 0, width = 300) rawConnection(raw(0L))
    setTkProgressBar <- function(pb, value, title = NULL, label = NULL) NULL
  }

  stop_if_not(
    is.list(inputs),
    !is.null(names(inputs)),
    all(names(inputs) %in% c("title", "label")),
    all(vapply(inputs, FUN = function(x) {
      if (is.null(x)) return(TRUE)
      if (!is.character(x)) return(FALSE)
      x %in% c("message", "non_sticky_message", "sticky_message")
    }, FUN.VALUE = FALSE))
  )
  
  ## Expand 'message' => c("non_sticky_message", "sticky_message")
  for (name in names(inputs)) {
    input <- inputs[[name]]
    if ("message" %in% input) {
      input <- setdiff(input, "message")
      input <- c(input, "non_sticky_message", "sticky_message")
    }
    inputs[[name]] <- unique(input)
  }

  backend_args <- handler_backend_args(...)

  reporter <- local({
    pb_config <- NULL

    ## Update tkProgressBar
    update_pb <- function(state, progression, ...) {
      ## Update 'title' and 'label' (optional)
      args <- message_to_backend_targets(progression, inputs = inputs, ...)
      for (name in names(args)) pb_config[[name]] <<- args[[name]]

      ## Update progress bar
      args <- pb_config
      args$value <- state$step
      do.call(what = setTkProgressBar, args = args)
    }

    list(
      reset = function(...) {
        pb_config <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        ## NOTE: 'pb_config' may be re-used for tkProgressBar:s
        if (config$clear) stop_if_not(is.null(pb_config))
        args <- c(
          backend_args,
          list(max = config$max_steps, initial = state$step),
          list(...)
        )

        ## tkProgressBar() arguments 'title' and 'label' must not be NULL;
        ## use the defaults
        for (name in c("title", "label")) {
          if (is.null(args[[name]])) {
            args[[name]] <- formals(tkProgressBar)[[name]]
          }
        }

        ## Create progress bar
        args <- args[names(args) %in% names(formals(tkProgressBar))]
        pb <- do.call(tkProgressBar, args = args)

        ## Record arguments used by setTkProgressBar() later on
        args$pb <- pb
        args <- args[names(args) %in% names(formals(setTkProgressBar))]
        pb_config <<- args
      },
        
      interrupt = function(config, state, progression, ...) {
        if (!state$enabled) return()
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        update_pb(state, progression, message = msg)
      },

      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        update_pb(state, progression)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb_config)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb_config$pb)
          pb_config <<- NULL
        } else {
          update_pb(state, progression)
        }
      }
    )
  })
  
  make_progression_handler("tkprogressbar", reporter, intrusiveness = intrusiveness, target = target, ...)
}
