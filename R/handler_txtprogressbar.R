#' Progression Handler: Progress Reported as Plain Progress Bars (Text) in the Terminal
#'
#' A progression handler for [utils::txtProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param style (integer) The progress-bar style according to [utils::txtProgressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Appearance:
#' Below is how this progress handler renders at 0%, 30% and 99% progress
#' for the three different `style` values that [utils::txtProgressBar()]
#' supports.
#'
#' With `handlers(handler_txtprogressbar(style = 1L))`:
#' ```r
#'
#' ====================================
#' ==========================================================
#' ```
#'
#' With `handlers(handler_txtprogressbar(style = 2L))`:
#' ```r
#' 
#' ====================================
#' ==========================================================
#' ```
#'
#' With `handlers(handler_txtprogressbar(style = 3L))`:
#' ```r  
#'   |                                                 |   0%
#'   |===============                                  |  30%
#'   |=================================================|  99%
#' ```
#'
#' @example incl/handler_txtprogressbar.R
#'
#' @importFrom utils file_test flush.console txtProgressBar setTxtProgressBar
#' @export
handler_txtprogressbar <- function(style = 3L, file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  reporter <- local({
    ## Import functions
    eraseTxtProgressBar <- function(pb) {
      pb_env <- environment(pb$getVal)
      with(pb_env, {
        if (style == 1L || style == 2L) {
          n <- .nb
        } else if (style == 3L) {
          n <- 3L + nw * width + 6L
        }
        cat("\r", strrep(" ", times = n), "\r", sep = "", file = file)
        flush.console()
      })
    }

    pb <- NULL

    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      pb <<- txtProgressBar(...)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, style = style, file = file)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times == 1L) return()
	make_pb(max = config$max_steps, style = style, file = file)
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
          setTxtProgressBar(pb, value = config$max_steps)
        }
        close(pb)
	pb <<- NULL
      }
    )
  })
  
  make_progression_handler("txtprogressbar", reporter, intrusiveness = intrusiveness, ...)
}
