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
      update = function(config, state, progression, ...) {
        if (state$enabled) cat(file = file, symbol)
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
        if (!state$enabled || config$times == 1L) return()
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
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("tkprogressbar_handler")) {
    if (!capabilities("tcltk")) {
      stop("tkprogressbar_handler requires TclTk support")
    }
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar
  } else {
    tkProgressBar <- function(...) rawConnection(raw(0L))
    setTkProgressBar <- function(...) NULL
  }
  
  reporter <- local({
    pb <- NULL
    
    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      pb <<- tkProgressBar(...)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, label = progression$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = progression$message)
        setTkProgressBar(pb, value = state$step, label = progression$message)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setTkProgressBar(pb, value = state$step, label = progression$message)
        }
      }
    )
  })
  
  progression_handler("tkprogressbar", reporter, intrusiveness = intrusiveness, ...)
}


#' Visual Progression Feedback for MS Windows
#'
#' A progression handler for [utils::winProgressBar()].
#'
#' @inheritParams progression_handler
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @export
winprogressbar_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), ...) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("winprogressbar_handler")) {
    if (.Platform$OS.type != "windows") {
      stop("winprogressbar_handler requires MS Windows: ",
           sQuote(.Platform$OS.type))
    }
    ## Import functions
    winProgressBar <- utils::winProgressBar
    setWinProgressBar <- utils::setWinProgressBar
  } else {
    winProgressBar <- function(...) rawConnection(raw(0L))
    setWinProgressBar <- function(...) NULL
  }
  
  reporter <- local({
    pb <- NULL
    
    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      pb <<- winProgressBar(...)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, label = progression$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = progression$message)
        setWinProgressBar(pb, value = state$step, label = progression$message)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setWinProgressBar(pb, value = state$step, label = progression$message)
        }
      }
    )
  })
  
  progression_handler("winprogressbar", reporter, intrusiveness = intrusiveness, ...)
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
  if (!is_fake("pbmcapply_handler")) {
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
  } else {
    progressBar <- function(..., style, substyle) utils::txtProgressBar(..., style = substyle)
    setTxtProgressBar <- function(...) NULL
    eraseTxtProgressBar <- function(pb) NULL
  }
  
  reporter <- local({
    ## Import functions

    pb <- NULL
    
    make_pb <- function(...) {
      if (!is.null(pb)) return(pb)
      pb <<- progressBar(...)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, style = style, substyle = substyle, file = file)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        make_pb(max = config$max_steps, style = style, substyle = substyle, file = file)
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
  if (!is_fake("progress_handler")) {
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
        tokens <- list(message = paste0(progression$message, ""))
        pb$tick(0, tokens = tokens)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (state$delta >= 0) {
          make_pb(format = format, total = config$max_steps,
                  clear = config$clear, show_after = config$enable_after)
          tokens <- list(message = paste0(progression$message, ""))
          pb$tick(state$delta, tokens = tokens)
        }
      },
        
      finish = function(config, state, progression, ...) {
        if (pb$finished) return()
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        reporter$update(config = config, state = state, progression = progression, ...)
        if (config$clear) pb$update(1.0)
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
#'  play when progress starts, is updated, and completes.  For silence, use `NA_integer_`.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @example incl/beepr_handler.R
#'
#' @export
beepr_handler <- function(initiate = 2L, update = 10L,  finish = 11L, intrusiveness = getOption("progressr.intrusiveness.auditory", 10), ...) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("beepr_handler")) {
    beepr_beep <- beepr::beep
  } else {
    beepr_beep <- function(sound, expr) NULL
  }

  beep <- function(sound) {
    ## Silence?
    if (is.na(sound)) return()
    beepr_beep(sound)
  }

  ## Reporter state
  reporter <- local({
    list(
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
	beep(initiate)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        beep(update)
      },
        
      finish = function(config, state, progression, ...) {
        if (!state$enabled) return()
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
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("notifier_handler")) {
    notifier_notify <- function(...) notifier::notify(...)
  } else {
    notifier_notify <- function(...) NULL
  }

  notify_ideally <- function(step, max_steps, message, p) {
    msg <- paste(c("", message), collapse = "")
    ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.0f%%", 100*step/max_steps)
    notifier_notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
  }

  notify <- function(step, max_steps, message) {
    msg <- paste(c("", message), collapse = "")
    ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.1f%%", 100*step/max_steps)
    notifier_notify(sprintf("[%s] %s (%d/%d)", ratio, msg, step, max_steps))
  }

  reporter <- local({
    finished <- FALSE
    
    list(
      reset = function(...) {
        finished <<- FALSE
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        notify(step = state$step, max_steps = config$max_steps, message = progression$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        notify(step = state$step, max_steps = config$max_steps, message = progression$message)
      },
        
      finish = function(config, state, progression, ...) {
        if (finished) return()
        if (!state$enabled) return()
        notify(step = state$step, max_steps = config$max_steps, message = progression$message)
	finished <<- TRUE
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
    t_init <- NULL
    
    add_to_log <- function(config, state, progression, ...) {
      t <- Sys.time()
      if (is.null(t_init)) t_init <<- t
      dt <- difftime(t, t_init, units = "secs")
      delay <- difftime(t, progression$time, units = "secs")
      message <- paste(c(progression$message, ""), collapse = "")
      entry <- list(now(t), dt, delay, progression$type, state$step, config$max_steps, state$delta, message, config$clear, state$enabled)
      msg <- do.call(sprintf, args = c(list("%s(%.3fs => +%.3fs) %s: %d/%d (%+d) '%s' {clear=%s, enabled=%s}"), entry))
      message(msg)
    }

    list(
      reset = function(...) {
        t_init <<- NULL
      },
      
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



#' Textual Progression Feedback that outputs a Newline
#'
#' @inheritParams progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII NL character (`'\n'` = `'\013'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [progression_handler()].
#'
#' @export
newline_handler <- function(symbol = "\n", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.debug", 0), ...) {
  reporter <- local({
    list(
      initiate = function(...) cat(file = file, symbol),
      update   = function(...) cat(file = file, symbol),
      finish   = function(...) cat(file = file, symbol)
    )
  })
  
  progression_handler("newline", reporter, intrusiveness = intrusiveness, ...)
}
