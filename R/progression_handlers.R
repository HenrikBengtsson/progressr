#' Auditory Progression Feedback
#'
#' A progression handler based on `cat("\a", file=stderr())`.
#'
#' @inheritParams progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII BEL character (`'\a'` = `'\007'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/ascii_alert_handler.R
#'
#' @export
ascii_alert_handler <- function(symbol = "\a", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.auditory", 10), ...) {
  reporter <- local({
    list(
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        cat(file = file, symbol)
      }
    )
  })

  progression_handler("ascii_alert", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [utils::txtProgressBar()].
#'
#' @inheritParams progression_handler
#'
#' @param style (integer) The progress-bar style according to [utils::txtProgressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/txtprogressbar_handler.R
#'
#' @importFrom utils file_test flush.console
#' @export
txtprogressbar_handler <- function(style = 3L, file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), ...) {
  reporter <- local({
    ## Import functions
    txtProgressBar <- utils::txtProgressBar
    setTxtProgressBar <- utils::setTxtProgressBar
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

    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- txtProgressBar(max = max_steps, style = style, file = file)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTxtProgressBar(pb, value = step)
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) {
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
          setTxtProgressBar(pb, value = max_steps)
        }
        close(pb)
      }
    )
  })
  
  progression_handler("txtprogressbar", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [tcltk::tkProgressBar()].
#'
#' @inheritParams progression_handler
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/tkprogressbar_handler.R
#'
#' @export
tkprogressbar_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), ...) {
  reporter <- local({
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    pb <- NULL
    
    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- tkProgressBar(max = max_steps, label = message)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTkProgressBar(pb, value = step, label = message)
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) {
          close(pb)
        } else {
          setTkProgressBar(pb, value = step, label = message)
        }
      }
    )
  })
  
  progression_handler("tkprogressbar", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [pbmcapply::progressBar()].
#'
#' @inheritParams progression_handler
#'
#' @param substyle (integer) The progress-bar substyle according to [pbmcapply::progressBar()].
#'
#' @param style (character) The progress-bar style according to [pbmcapply::progressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/pbmcapply_handler.R
#'
#' @importFrom utils file_test flush.console
#' @export
pbmcapply_handler <- function(substyle = 3L, style = "ETA", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), ...) {
  reporter <- local({
    ## Import functions
    progressBar <- pbmcapply::progressBar
    setTxtProgressBar <- utils::setTxtProgressBar
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
        flush.console()
      })
    }

    pb <- NULL

    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- progressBar(max = max_steps, style = style, substyle = substyle, file = file)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTxtProgressBar(pb, value = step)
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) {
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
          setTxtProgressBar(pb, value = step)
        }
        close(pb)
      }
    )
  })
  
  progression_handler("pbmcapply", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [progress::progress_bar()].
#'
#' @inheritParams progression_handler
#'
#' @param format (character string) The format of the progress bar.
#'
#' @param show_after (numeric) Number of seconds to wait before displaying
#' the progress bar.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/progress_handler.R
#'
#' @export
progress_handler <- function(format = "[:bar] :percent :message", show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), ...) {
  reporter <- local({
    ## Import functions
    progress_bar <- progress::progress_bar

    pb <- NULL
    
    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- progress_bar$new(format = format,
                                total = max_steps,
                                clear = clear, show_after = show_after)
        tokens <- list(message = paste0(message, ""))
        pb$tick(0, tokens = tokens)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (delta > 0) {
          tokens <- list(message = paste0(message, ""))
          pb$tick(delta, tokens = tokens)
        }
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (delta > 0) {
          tokens <- list(message = paste0(message, ""))
          pb$tick(delta, tokens = tokens)
        }
      }
    )
  })

  progression_handler("progress", reporter, intrusiveness = intrusiveness, ...)
}



#' Auditory Progression Feedback
#'
#' A progression handler for [beepr::beep()].
#'
#' @inheritParams progression_handler
#'
#' @param initiate,update,finish (integer) Indices of [beepr::beep()] sounds to
#'  play when progress starts, is updated, and completes.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/beepr_handler.R
#'
#' @export
beepr_handler <- function(initiate = 2L, update = 10L,  finish = 11L, intrusiveness = getOption("progressr.intrusiveness.auditory", 10), ...) {
  ## Reporter state
  reporter <- local({
    ## Import functions
    beep <- beepr::beep

    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(initiate)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(update)
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(finish)
      }
    )
  })
  
  progression_handler("beepr", reporter, intrusiveness = intrusiveness, ...)
}



#' Operating-System Specific Progression Feedback
#'
#' A progression handler for [notifier::notify()].
#'
#' @inheritParams progression_handler
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/notifier_handler.R
#'
#' @export
notifier_handler <- function(intrusiveness = getOption("progressr.intrusiveness.notifier", 10), ...) {
  reporter <- local({
    notify_ideally <- function(step, max_steps, message, p) {
      msg <- paste(c("", message), collapse = "")
      ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.0f%%", 100*step/max_steps)
      notifier::notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
    }

    notify <- function(step, max_steps, message) {
      msg <- paste(c("", message), collapse = "")
      ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.1f%%", 100*step/max_steps)
      notifier::notify(sprintf("[%s] %s (%d/%d)", ratio, msg, step, max_steps))
    }

    list(
      initiate = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      finish = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      }
    )
  })
  
  progression_handler("notifier", reporter, intrusiveness = intrusiveness, ...)
}




#' Textual Progression Feedback for Debug Purposes
#'
#' @inheritParams progression_handler
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/debug_handler.R
#'
#' @export
debug_handler <- function(intrusiveness = getOption("progressr.intrusiveness.debug", 0), ...) {
  reporter <- local({
    first_progression <- NULL
    add_to_log <- function(type, step, max_steps, delta, message, clear, timestamps, ..., progression) {
      if (is.null(first_progression)) first_progression <<- progression
      t <- Sys.time()
      dt <- difftime(progression$time, first_progression$time, units = "secs")
      delay <- difftime(t, progression$time, units = "secs")
      if (missing(step)) step <- NA_integer_
      message <- paste(c(message, ""), collapse = "")
      entry <- list(now(t), dt, delay, type, step, max_steps, delta, message, clear)
      msg <- do.call(sprintf, args = c(list("%s(%.3fs => +%.3fs) %s: %d/%d (%+d) '%s' {clear=%s}"), entry))
      message(msg)
    }

    list(
      initiate = function(...) {
        add_to_log("initiate", ...)
      },
        
      update = function(...) {
        add_to_log("update", ...)
      },
        
      finish = function(...) {
        add_to_log("finish", ...)
      }
    )
  })
  
  progression_handler("debug", reporter, intrusiveness = intrusiveness, ...)
}
