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
#' @param complete,incomplete (function) Functions that take "complete" and
#' "incomplete" strings that comprise the progress bar as input and annotate
#' them to reflect their two different parts.  The default is to annotation
#' them with two different background colors and the same foreground color
#' using the \pkg{crayon} package.
#' 
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{crayon} package.
#'
#' @example incl/handler_pbcol.R
#'
#' @importFrom utils flush.console
#' @export
handler_pbcol <- function(adjust = 0.0, pad = 1L, complete = function(s) crayon::bgBlue(crayon::white(s)), incomplete = function(s) crayon::bgCyan(crayon::white(s)), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  crayon_enabled <- getOption("crayon.enabled", NULL)
  if (is.null(crayon_enabled)) crayon_enabled <- crayon::has_color()

  cat_ <- function(...) {
    cat(..., sep = "", collapse = "", file = stderr())
    flush.console()
  }
  
  erase_progress_bar <- function() {
    cat_(c("\r", rep(" ", times = getOption("width")), "\r"))
  }
  
  redraw_progress_bar <- function(ratio, message, spin = " ") {
    stop_if_not(ratio >= 0, ratio <= 1)
    if (crayon_enabled) {
      options(crayon.enabled = TRUE)
      on.exit(options(crayon.enabled = TRUE), add = TRUE)
    }
    pbstr <- pbcol(
      fraction = ratio,
      msg = message,
      adjust = adjust,
      pad = pad,
      complete = complete,
      incomplete = incomplete,
      spin = spin,
    )
    cat_("\r", pbstr)
  }
  
  reporter <- local({
    spin_state <- 0L
    spinner <- c("-", "\\", "|", "/", "-", "\\", "|", "/")
    
    list(
      initiate = function(config, state, ...) {
        if (!state$enabled || config$times <= 2L) return()
        ratio <- if (config$max_steps == 0) 1 else state$step / config$max_steps
        redraw_progress_bar(ratio = ratio, message = state$message, spin = spinner[spin_state+1L])
      },
      
      reset = function(...) {
        erase_progress_bar()
      },
      
      hide = function(...) {
        erase_progress_bar()
      },

      unhide = function(config, state, ...) {
        if (!state$enabled || config$times <= 2L) return()
        ratio <- if (config$max_steps == 0) 1 else state$step / config$max_steps
        redraw_progress_bar(ratio = ratio, message = state$message, spin = spinner[spin_state+1L])
      },

      interrupt = function(config, state, progression, ...) {
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat_(msg)
      },

      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (state$delta < 0) return()
        spin_state <<- (spin_state+1L) %% length(spinner)
        ratio <- if (config$max_steps == 0) 1 else state$step / config$max_steps
        redraw_progress_bar(ratio = ratio, message = state$message, spin = spinner[spin_state+1L])
      },

      finish = function(config, state, progression, ...) {
        if (config$clear) {
          erase_progress_bar()
        } else {
          redraw_progress_bar(ratio = 1, message = state$message, spin = " ")
          cat("\n", file = stderr())
        }
      }
    )
  })

  make_progression_handler("pbcol", reporter, intrusiveness = intrusiveness, target = target, ...)
}



pbcol <- function(fraction = 0.0, msg = "", adjust = 0, pad = 1L, width = getOption("width") - 1L, complete = function(s) crayon::bgBlue(crayon::white(s)), incomplete = function(s) crayon::bgCyan(crayon::white(s)), spin = " ") {
  if (length(msg) == 0L) msg <- ""
  stop_if_not(length(msg) == 1L, is.character(msg))

  fraction <- as.numeric(fraction)
  stop_if_not(length(fraction) == 1L, !is.na(fraction),
            fraction >= 0, fraction <= 1)
            
  width <- as.integer(width)
  stop_if_not(length(width) == 1L, !is.na(width), width > 0L)

  msgfraction <- sprintf(" %3.0f%%", 100 * fraction)
  
  ## Pad 'fullmsg' to align horizontally
  nmsg <- nchar(msg) + nchar(msgfraction)
  msgpad <- (width - 2 * pad) - nmsg

  ## Truncate 'msg'?
  if (msgpad < 0) {
    msg <- substr(msg, start = pad, stop = nchar(msg) + msgpad - pad)
    msg <- substr(msg, start = 1L, stop = nchar(msg) - 3L)
    msg <- paste(msg, "...", sep = "")
    msgpad <- (width - 2 * pad) - nchar(msg) - nchar(msgfraction)
    stop_if_not(msgpad >= 0)
  }

  ## Pad 'msg'
  lpad <- floor(   adjust  * msgpad) + pad
  rpad <- floor((1-adjust) * msgpad)
  stop_if_not(lpad >= 0L, rpad >= 0L)
  pmsg <- sprintf("%*s%s%*s%s%s%*s", lpad, "", msg, rpad, "", msgfraction, spin, pad, "")

  ## Make progress bar
  len <- round(fraction * nchar(pmsg), digits = 0L)
  lmsg <- substr(pmsg, start = 1L, stop = len)
  rmsg <- substr(pmsg, start = len + 1L, stop = nchar(pmsg))
  if (!is.null(complete)) lmsg <- complete(lmsg)
  if (!is.null(incomplete)) rmsg <- incomplete(rmsg)
  bar <- paste(lmsg, rmsg, sep = "")
  
  bar
}
