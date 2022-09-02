#' Progression Handler: Progress Reported as a MS Windows Progress Bars in the GUI
#'
#' A progression handler for `winProgressBar()` in the \pkg{utils} package.
#'
#' @inheritParams make_progression_handler
#' 
#' @param inputs (named list) Specifies from what sources the MS Windows
#' progress elements 'title' and 'label' should be updated. Valid sources are
#' `"message"`, `"sticky_message"` and `"non_sticky_message"`, where
#' `"message"` is short for `c("non_sticky_message", "sticky_message")`. For
#' example, `inputs = list(title = "sticky_message", label = "message")`
#' will update the 'title' component from sticky messages only,
#' whereas the 'label' component is updated using any message.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(handler_winprogressbar())
#' with_progress(y <- slow_sum(1:100))
#' }}
#' 
#' @section Requirements:
#' This progression handler requires MS Windows.
#'
#' @export
handler_winprogressbar <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", inputs = list(title = NULL, label = "message"), ...) {
  ## Additional arguments passed to the progress-handler backend
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
    winProgressBar <- function(title = "R progress bar", label = "", min = 0, max = 1, initial = 0, width = 300) rawConnection(raw(0L))
    setWinProgressBar <- function(pb, value, title = NULL, label = NULL) NULL
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
    
    ## Update winProgressBar
    update_pb <- function(state, progression) {
      ## Update 'title' and 'label' (optional)
      args <- message_to_backend_targets(progression, inputs = inputs)
      for (name in names(args)) pb_config[[name]] <<- args[[name]]

      ## Update progress bar
      args <- pb_config
      args$value <- state$step
      do.call(what = setWinProgressBar, args = args)
    }
    
    list(
      reset = function(...) {
        pb_config <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        ## NOTE: 'pb_config' may be re-used for winProgressBar:s
        if (config$clear) stop_if_not(is.null(pb_config))
        args <- c(
          backend_args,
          list(max = config$max_steps, initial = state$step),
          list(...)
        )

        ## winProgressBar() arguments 'title' and 'label' must not be NULL;
        ## use the defaults
        for (name in c("title", "label")) {
          if (is.null(args[[name]])) {
            args[[name]] <- formals(winProgressBar)[[name]]
          }
        }
        
        ## WORKAROUND: If the progress bar is created with label = "", then
        ## it will *not* be possible to modify it with winSetProgressBar()
        ## afterward, cf. "Space will be allocated for the label only if
        ## it is non-empty" in help("winProgressBar", package = "utils").
        if (args$label == "") args$label <- " "

        ## Create progress bar
        args <- args[names(args) %in% names(formals(winProgressBar))]
        pb <- do.call(winProgressBar, args = args)

        ## Record arguments used by setWinProgressBar() later on
        args$pb <- pb
        args <- args[names(args) %in% names(formals(setWinProgressBar))]
        pb_config <<- args
        
        pb_config
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
  
  make_progression_handler("winprogressbar", reporter, intrusiveness = intrusiveness, target = target, ...)
}
