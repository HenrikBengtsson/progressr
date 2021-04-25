#' Progression Handler: Progress Reported as Plain Progress Bars (Text) in the Terminal
#'
#' A progression handler for [utils::txtProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param style (integer) The progress-bar style according to
#' [utils::txtProgressBar()].
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
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)

  reporter <- local({
    pb <- NULL
    
    make_pb <- function(max, ...) {
      if (!is.null(pb)) return(pb)
      ## SPECIAL CASE: utils::txtProgressBar() does not support max == min
      if (max == 0) {
        pb <<- voidProgressBar()
      } else {
        args <- c(list(max = max, ...), backend_args)
        pb <<- do.call(txtProgressBar, args = args)
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
        make_pb(max = config$max_steps, style = style, file = file)
      },

      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, style = style, file = file)
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
          setTxtProgressBar(pb, value = config$max_steps)
        }
        close(pb)
        pb <<- NULL
      }
    )
  })

  
  make_progression_handler("txtprogressbar", reporter, intrusiveness = intrusiveness, target = target, ...)
}


#' @importFrom utils txtProgressBar
voidProgressBar <- function(...) {
  pb <- txtProgressBar()
  class(pb) <- c("voidProgressBar", class(pb))
  pb
}


## Erase a utils::txtProgressBar()
eraseTxtProgressBar <- function(pb) {
  if (inherits(pb, "voidProgressBar")) return()
  pb_env <- environment(pb$getVal)
  with(pb_env, {
    if (style == 1L || style == 2L) {
      n <- .nb
    } else if (style == 3L) {
      n <- 3L + nw * width + 6L
    }
    cat("\r", strrep(" ", times = n), "\r", sep = "", file = file)        
    flush.console()

    ## Reset internal counter, cf. utils::txtProgressBar()
    .nb <- 0L
    .pc <- -1L
  })
}

## Redraw a utils::txtProgressBar()
redrawTxtProgressBar <- function(pb) {
  if (inherits(pb, "voidProgressBar")) return()
  setTxtProgressBar(pb, value = pb$getVal())
}

