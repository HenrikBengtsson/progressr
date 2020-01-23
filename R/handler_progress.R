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
#' Below is how this progress handler renders by default at 0%, 30% and 99%
#' progress:
#' 
#' With `handlers(handler_progress())`:
#' ```r
#' [-------------------------------------------------]   0% 
#' [====>--------------------------------------------]  10% 
#' [================================================>]  99% 
#' ```
#'
#' If the progression updates have messages, they will appear like:
#' ```r
#' [-----------------------------------------]   0% Starting
#' [===========>----------------------------]  30% Importing
#' [=====================================>]  99% Summarizing
#' ```
#'
#' @example incl/handler_progress.R
#'
#' @export
handler_progress <- function(format = "[:bar] :percent :message", show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  if (!is_fake("handler_progress")) {
    progress_bar <- progress::progress_bar
  } else {
    progress_bar <- list(
      new = function(...) list(
        finished = FALSE,
        tick = function(...) NULL,
        update = function(...) NULL
      )
    )
  }
  
  reporter <- local({
    pb <- NULL

    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      pb <<- progress_bar$new(...)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        tokens <- list(message = paste0(state$message, ""))
        pb$tick(0, tokens = tokens)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (state$delta >= 0) {
          make_pb(format = format, total = config$max_steps,
                  clear = config$clear, show_after = config$enable_after)
          tokens <- list(message = paste0(state$message, ""))
          pb$tick(state$delta, tokens = tokens)
        }
      },
        
      finish = function(config, state, progression, ...) {
        if (is.null(pb) || pb$finished) return()
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        reporter$update(config = config, state = state, progression = progression, ...)
        if (config$clear && !pb$finished) pb$update(1.0)
      }
    )
  })

  make_progression_handler("progress", reporter, intrusiveness = intrusiveness, ...)
}
