#' Progression Handler: Progress Reported via 'pbmcapply' Progress Bars (Text) in the Terminal
#'
#' A progression handler for [pbmcapply::progressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param style (character) The progress-bar style according to [pbmcapply::progressBar()].
#'
#' @param substyle (integer) The progress-bar substyle according to [pbmcapply::progressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{pbmcapply} package.
#'
#' @section Appearance:
#' Since `style = "txt"` corresponds to using [handler_txtprogressbar()]
#' with `style = substyle`, the main usage of this handler is with
#' `style = "ETA"` (default) for which `substyle` is ignored.
#' Below is how this progress handler renders by default at 0%, 30% and 99%
#' progress:
#' 
#' With `handlers(handler_pbmcapply())`:
#' ```r
#'  |                                         |   0%, ETA NA
#'  |===========                           |  30%, ETA 01:32
#'  |======================================|  99%, ETA 00:01
#' ```
#'
#' @example incl/handler_pbmcapply.R
#'
#' @importFrom utils file_test flush.console txtProgressBar setTxtProgressBar
#' @export
handler_pbmcapply <- function(substyle = 3L, style = "ETA", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)

  if (!is_fake("handler_pbmcapply")) {
    progressBar <- pbmcapply::progressBar
    eraseTxtProgressBar <- function(pb) {
      pb_env <- environment(pb$getVal)
      with(pb_env, {
        style_eta <- exists(".time0", inherits = FALSE)
        if (!style_eta) {
          if (style == 1L || style == 2L) {
            n <- .nb
          } else if (style == 3L) {
            n <- 3L + nw * width + 6L
          }
        } else {
          ## FIXME: Seems to work; if not, see pbmcapply:::txtProgressBarETA()
          n <- width
        }
        cat("\r", strrep(" ", times = n), "\r", sep = "", file = file)
        .nb <- 0L
        flush.console()
      })
    }
  } else {
    progressBar <- function(..., style, substyle) txtProgressBar(..., style = substyle)
    setTxtProgressBar <- function(...) NULL
    eraseTxtProgressBar <- function(pb) NULL
    redrawTxtProgressBar <- function(pb) NULL
  }
  
  reporter <- local({
    ## Import functions

    pb <- NULL
    
    make_pb <- function(max, ...) {
      if (!is.null(pb)) return(pb)
      
      ## SPECIAL CASE: pbmcapply::progressBar() does not support max == min
      ## 
      if (max == 0) {
        pb <<- voidProgressBar()
      } else {
        args <- c(list(...), backend_args)
        pb <<- do.call(progressBar, args = args)
      }
      
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },

      hide = function(...) {
        if (is.null(pb)) return()
        eraseTxtProgressBar(pb)
      },

      unhide = function(...) {
        if (is.null(pb)) return()
        redrawTxtProgressBar(pb)
      },

      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, style = style, substyle = substyle, file = file)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(max = config$max_steps, style = style, substyle = substyle, file = file)
        if (inherits(progression, "sticky")) {
          eraseTxtProgressBar(pb)
          message(paste0(state$message, ""))
          redrawTxtProgressBar(pb)
        }
        if (progression$amount == 0) return()
        setTxtProgressBar(pb, value = state$step)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          eraseTxtProgressBar(pb)
          ## Suppress newline outputted by close()
          pb_env <- environment(pb$getVal)
          file <- pb_env$file
          pb_env$file <- tempfile()
          on.exit({
            if (file_test("-f", pb_env$file)) file.remove(pb_env$file)
            pb_env$file <- file
          })
        } else {
          setTxtProgressBar(pb, value = state$step)
        }
        close(pb)
	pb <<- NULL
      }
    )
  })
  
  make_progression_handler("pbmcapply", reporter, intrusiveness = intrusiveness, target = target, ...)
}
