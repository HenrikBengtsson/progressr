#' Progression Handler: Progress Reported as an ANSI Background Color in the Terminal
#'
#' @inheritParams make_progression_handler 
#'
#' @param adjust (numeric) The adjustment of the progress update,
#' where `adjust = 0` positions the message to the very left, and
#' `adjust = 1` positions the message to the very right.
#'
#' @param pad (integer) Amount of padding on each side of the message,
#' where padding is done by spaces.
#'
#' @param done_col,todo_col (character string) The \pkg{crayon} background
#' colors used for the progress bar, where `done_col` is used for the part
#' of the progress bar that is already done and `todo_col` for what remains.
#' 
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{crayon} package.
#'
#' @export
handler_pbcol <- function(adjust = 0.0, pad = 1L, done_col = "blue", todo_col = "cyan", intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  cat_ <- function(...) {
    cat(..., sep = "", collapse = "", file = stderr())
  }
  
  erase_progress_bar <- function() {
    cat_(c("\r", rep(" ", times = getOption("width") - 1L), "\r"))
  }
  
  redraw_progress_bar <- function(ratio, message) {
    stop_if_not(ratio >= 0, ratio <= 1)
    pbstr <- pbcol(
      fraction = ratio,
      msg = message,
      adjust = adjust,
      pad = pad,
      done_col = done_col,
      todo_col = todo_col
    )
    cat_("\r", pbstr)
  }
  
  reporter <- local({
    list(
      reset = function(...) {
        erase_progress_bar()
      },
      
      finish = function(...) {
        erase_progress_bar()
      },
      
      hide = function(...) {
        erase_progress_bar()
      },

      unhide = function(config, state, ...) {
        if (!state$enabled || config$times <= 2L) return()
        redraw_progress_bar(ratio = state$step / config$max_steps, message = state$message)
      },
      
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (state$delta <= 0) return()
        redraw_progress_bar(ratio = state$step / config$max_steps, message = state$message)
      }
    )
  })

  make_progression_handler("pbcol", reporter, intrusiveness = intrusiveness, target = target, ...)
}



pbcol <- function(fraction = 0.0, msg = "", adjust = 0, pad = 1L, width = getOption("width"), done_col = "blue", todo_col = "cyan") {
  bgColor <- function(s, col) {
    bgFcn <- switch(col,
      black   = crayon::bgBlack,
      blue    = crayon::bgBlue,
      cyan    = crayon::bgCyan,
      green   = crayon::bgGreen,
      magenta = crayon::bgMagenta,
      red     = crayon::bgRed,
      yellow  = crayon::bgYellow,
      white   = crayon::bgWhite,
      stop("Unknown 'crayon' background color: ", sQuote(col))
    )
    bgFcn(s)
  }
  
  fraction <- as.numeric(fraction)
  stopifnot(length(fraction) == 1L, !is.na(fraction),
            fraction >= 0, fraction <= 1)
  width <- as.integer(width)
  stopifnot(length(width) == 1L, !is.na(width), width > 0L)
  
  msgpad <- (width - 2 * pad) - nchar(msg)
  if (msgpad < 0) {
    msg <- substr(msg, start = pad, stop = nchar(msg) + msgpad - pad)
    msg <- substr(msg, start = 1L, stop = nchar(msg) - 3L)
    msg <- paste(msg, "...", sep = "")
    msgpad <- (width - 2 * pad) - nchar(msg)
  }
  lpad <- floor(adjust * msgpad) + pad
  rpad <- (msgpad - lpad) + pad
  pmsg <- sprintf("%*s%s%*s", lpad, "", msg, rpad, "")

  len <- round(fraction * nchar(pmsg), digits = 0L)
  lmsg <- substr(pmsg, start = 1L, stop = len)
  rmsg <- substr(pmsg, start = len + 1L, stop = nchar(pmsg))
  lmsg <- bgColor(lmsg, done_col)
  rmsg <- bgColor(rmsg, todo_col)
  paste(lmsg, rmsg, sep = "")
}
