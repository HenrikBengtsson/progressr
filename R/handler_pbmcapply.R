#' Progression Handler: Progress Reported via 'pbmcapply' Progress Bars (Text) in the Terminal
#'
#' A progression handler for [pbmcapply::progressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @inheritParams handler_txtprogressbar
#'
#' @param char (character) The symbols to form the progress bar for
#' [utils::txtProgressBar()].
#'
#' @param style (character) The progress-bar style according to
#" [pbmcapply::progressBar()].
#'
#' @param substyle (integer) The progress-bar substyle according to
#' [pbmcapply::progressBar()].
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{pbmcapply} package.
#'
#' @section Appearance:
#' Below are a few examples on how to use and customize this progress handler.
#' In all cases, we use `handlers(global = TRUE)`.
#' Since `style = "txt"` corresponds to using [handler_txtprogressbar()]
#' with `style = substyle`, the main usage of this handler is with
#' `style = "ETA"` (default) for which `substyle` is ignored.
#'
#' ```{asciicast handler_pbmcapply-default}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers("pbmcapply")
#' y <- slow_sum(1:25)
#' ```
#'
#' @example incl/handler_pbmcapply.R
#'
#' @importFrom utils file_test flush.console txtProgressBar setTxtProgressBar
#' @export
handler_pbmcapply <- function(char = "=", substyle = 3L, style = "ETA", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(char = char, substyle = substyle, style = style, ...)

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
      ## (its 'min' argument defaults to 0)
      if (max == 0) {
        pb_tmp <- txtProgressBar()
        class(pb_tmp) <- c("voidProgressBar", class(pb_tmp))
      } else {
        args <- c(list(max = max, ...), backend_args)
        pb_tmp <- do.call(progressBar, args = args)
      }
      pb <<- pb_tmp
      
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

      interrupt = function(config, state, progression, ...) {
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat(msg, file = file)
      },

      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        stop_if_not(is.null(pb))
        make_pb(max = config$max_steps, file = file)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(max = config$max_steps, file = file)
        stop_if_not(!is.null(pb))
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
