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
#' @importFrom utils flush.console
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
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- txtProgressBar(max = max_steps, style = style, file = file)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTxtProgressBar(pb, value = step)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) {
	  eraseTxtProgressBar(pb)
	  ## Suppress newline outputted by close()
          pb_env <- environment(pb$getVal)
	  file <- pb_env$file
	  pb_env$file <- tempfile()
	  on.exit({
	    file.remove(pb_env$file)
	    pb_env$file <- file
	  })
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
#' @export
tkprogressbar_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 10), ...) {
  reporter <- local({
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    pb <- NULL
    
    list(
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- tkProgressBar(max = max_steps)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTkProgressBar(pb, value = step)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) close(pb)
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
#' @importFrom utils flush.console
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
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- progressBar(max = max_steps, style = style, substyle = substyle, file = file)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        setTxtProgressBar(pb, value = step)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (clear) {
	  eraseTxtProgressBar(pb)
	  ## Suppress newline outputted by close()
          pb_env <- environment(pb$getVal)
	  file <- pb_env$file
	  pb_env$file <- tempfile()
	  on.exit({
	    file.remove(pb_env$file)
	    pb_env$file <- file
	  })
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
#' @param show_after (numeric) Number of seconds to wait before displaying the progress bar.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @export
progress_handler <- function(show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), ...) {
  reporter <- local({
    ## Import functions
    progress_bar <- progress::progress_bar

    pb <- NULL
    
    list(
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        pb <<- progress_bar$new(total = max_steps,
                                clear = clear, show_after = show_after)
        pb$tick(0)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (delta > 0) pb$tick(delta)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        if (delta > 0) pb$tick(delta)
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
#' @param setup,update,done (integer) Indices of [beepr::beep()] sounds to
#'  play when progress starts, is updated, and completes.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @export
beepr_handler <- function(setup = 2L, update = 10L,  done = 11L, intrusiveness = getOption("progressr.intrusiveness.auditory", 10), ...) {
  ## Reporter state
  reporter <- local({
    ## Import functions
    beep <- beepr::beep

    list(
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(setup)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(update)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        beep(done)
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
      notifier::notify(sprintf("[%s] %s (Step %d of %d)", ratio, msg, step, max_steps))
    }

    list(
      setup = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      update = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      done = function(step, max_steps, delta, message, clear, timestamps, ...) {
        notify(step = step, max_steps = max_steps, message = message)
      }
    )
  })
  
  progression_handler("notifier", reporter, intrusiveness = intrusiveness, ...)
}
