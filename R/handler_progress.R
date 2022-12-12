#' Progression Handler: Progress Reported via 'progress' Progress Bars (Text) in the Terminal
#'
#' A progression handler for [progress::progress_bar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param format (character string) The format of the progress bar.
#'
#' @param show_after (numeric) Number of seconds to wait before displaying
#' the progress bar.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{progress} package.
#'
#' @section Appearance:
#' Below are a few examples on how to use and customize this progress handler.
#' In all cases, we use `handlers(global = TRUE)`.
#'
#' ```{asciicast handler_progress-default}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers("progress")
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_progress-complete}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_progress(complete = "#"))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_progress-format-1}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_progress(format = ":spin [:bar] :percent :message"))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_progress-format-2}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_progress(format = ":percent [:bar] :eta :message"))
#' y <- slow_sum(1:25)
#' ```
#'
#' @example incl/handler_progress.R
#'
#' @export
handler_progress <- function(format = ":spin [:bar] :percent :message", show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)

  ## Force evaluation for 'format' here in case 'crayon' is used.  This
  ## works around the https://github.com/r-lib/crayon/issues/48 problem
  stop_if_not(is.character(format), length(format) == 1L, !is.na(format))
  
  if (!is_fake("handler_progress")) {
    progress_bar <- progress::progress_bar
    get_private <- function(pb) {
      pb$.__enclos_env__$private
    }
    erase_progress_bar <- function(pb) {
      if (pb$finished) return()
      private <- get_private(pb)
      private$clear_line(private$width)
      private$cursor_to_start()
    }
    redraw_progress_bar <- function(pb, tokens = list()) {
      if (pb$finished) return()
      private <- get_private(pb)
      private$last_draw <- ""
      private$render(tokens)
    }
  } else {
    progress_bar <- list(
      new = function(...) list(
        finished = FALSE,
        tick = function(...) NULL,
        update = function(...) NULL,
        message = function(...) NULL
      )
    )
    get_private <- function(pb) NULL
    erase_progress_bar <- function(pb) NULL
    redraw_progress_bar <- function(pb, tokens = list()) NULL
  }

  reporter <- local({
    pb <- NULL
    
    make_pb <- function(format, total, clear, show_after, ...) {
      if (!is.null(pb)) return(pb)
      stop_if_not(
        is.character(format), length(format) == 1L,
        is.numeric(total), length(total) == 1L,
        is.logical(clear), length(clear) == 1L,
        is.numeric(show_after), length(show_after) == 1L
      )
      args <- c(list(format = format, total = total, clear = clear,
                     show_after = show_after, force = TRUE, ...),
                backend_args)
      pb <<- do.call(progress_bar$new, args = args)
      pb
    }

    last_tokens <- list()
    pb_tick <- function(pb, delta = 0, message = NULL, ...) {
      if (isTRUE(pb$finished)) return()
      
      ## WORKAROUND: https://github.com/r-lib/progress/issues/119
      private <- get_private(pb)
      if (!is.null(private) && private$total == 0) return()
      
      tokens <- list(message = paste0(message, ""))
      last_tokens <<- tokens
      if (delta < 0) return()
      pb$tick(delta, tokens = tokens)
    }

    pb_update <- function(pb, ratio, ...) {
      if (isTRUE(pb$finished)) return()
      
      ## WORKAROUND: https://github.com/r-lib/progress/issues/119
      private <- get_private(pb)
      if (!is.null(private) && private$total == 0) return()
      
      pb$update(ratio = ratio, ...)
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },

      hide = function(...) {
        if (is.null(pb)) return()
        erase_progress_bar(pb)
      },

      unhide = function(...) {
        if (is.null(pb)) return()
        redraw_progress_bar(pb, tokens = last_tokens)
      },

      interrupt = function(config, state, progression, ...) {
        if (is.null(pb)) return()
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat(msg, file = stderr())
      },

      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        stop_if_not(is.null(pb))
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        pb_tick(pb, 0, message = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        if (inherits(progression, "sticky") && length(state$message) > 0) {
          pb$message(state$message)
        }
        pb_tick(pb, state$delta, message = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!pb$finished) {
          make_pb(format = format, total = config$max_steps,
                  clear = config$clear, show_after = config$enable_after)
          reporter$update(config = config, state = state, progression = progression, ...)
          if (config$clear) pb_update(pb, ratio = 1.0)
        }
        pb <<- NULL
      }
    )
  })

  make_progression_handler("progress", reporter, intrusiveness = intrusiveness, target = target, ...)
}
