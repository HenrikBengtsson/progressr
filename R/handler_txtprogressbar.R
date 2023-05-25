#' Progression Handler: Progress Reported as Plain Progress Bars (Text) in the Terminal
#'
#' A progression handler for [utils::txtProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param char (character) The symbols to form the progress bar for
#' [utils::txtProgressBar()]. Contrary to `txtProgressBar()`, this handler
#' supports also ANSI-colored symbols.
#'
#' @param style (integer) The progress-bar style according to
#' [utils::txtProgressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Appearance:
#' Below are a few examples on how to use and customize this progress handler.
#' In all cases, we use `handlers(global = TRUE)`.
#'
#' ```{asciicast handler_txtprogressbar-default}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers("txtprogressbar")
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_txtprogressbar-style-1}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_txtprogressbar(style = 1L))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_txtprogressbar-style-3}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_txtprogressbar(style = 3L))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_txtprogressbar-char}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_txtprogressbar(char = "#"))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_txtprogressbar-char-width-2}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_txtprogressbar(char = "<>"))
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_txtprogressbar-char-ansi}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_txtprogressbar(char = cli::col_red(cli::symbol$heart)))
#' y <- slow_sum(1:25)
#' ```
#'
#' @example incl/handler_txtprogressbar.R
#'
#' @importFrom utils file_test flush.console setTxtProgressBar
#' @export
handler_txtprogressbar <- function(char = "=", style = 3L, file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(char = char, style = style, ...)

  reporter <- local({
    pb <- NULL

    make_pb <- function(max, ...) {
      if (!is.null(pb)) return(pb)
      args <- c(list(max = max, ...), backend_args)
      pb <<- do.call(txtProgressBar2, args = args)
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
        if (is.null(pb)) return()
        
        eraseTxtProgressBar(pb)
        redrawTxtProgressBar(pb)
        
        msg <- conditionMessage(progression)
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat(msg, file = file)
      },

      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        stop_if_not(is.null(pb))
        make_pb(max = config$max_steps, file = file)
      },

      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, file = file)
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


#' @importFrom utils txtProgressBar
txtProgressBar2 <- function(min = 0, max = 1, ..., char) {
  ## SPECIAL CASE: utils::txtProgressBar() does not support max == min
  if (max == min) {
    pb <- txtProgressBar()
    class(pb) <- c("voidProgressBar", class(pb))
    return(pb)
  }

  ## SPECIAL CASE: Support ANSI-colored 'char' strings
  clean_char <- drop_ansi(char)
  pb <- txtProgressBar(min = min, max = max, ..., char = clean_char)
  if (clean_char != char) {
    env <- environment(pb$up)
    env$char <- char
    env$nw <- nchar(clean_char)
  }
  
  pb
}
    
