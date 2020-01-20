#' Auditory Progression Feedback
#'
#' A progression handler based on `cat("\a", file=stderr())`.
#'
#' @inheritParams make_progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII BEL character (`'\a'` = `'\007'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/ascii_alert_handler.R
#'
#' @export
ascii_alert_handler <- function(symbol = "\a", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.auditory", 5.0), target = c("terminal", "audio"), ...) {
  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        if (state$enabled && progression$amount != 0) cat(file = file, symbol)
      }
    )
  })

  make_progression_handler("ascii_alert", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
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
#' @example incl/txtprogressbar_handler.R
#'
#' @importFrom utils file_test flush.console txtProgressBar setTxtProgressBar
#' @export
txtprogressbar_handler <- function(style = 3L, file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
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



#' Visual Progression Feedback
#'
#' A progression handler for [tcltk::tkProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/tkprogressbar_handler.R
#'
#' @export
tkprogressbar_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "terminal", ...) {
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
        make_pb(max = config$max_steps, label = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = state$message)
        setTkProgressBar(pb, value = state$step, label = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setTkProgressBar(pb, value = state$step, label = state$message)
        }
      }
    )
  })
  
  make_progression_handler("tkprogressbar", reporter, intrusiveness = intrusiveness, ...)
}


#' Visual Progression Feedback for MS Windows
#'
#' A progression handler for [utils::winProgressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @export
winprogressbar_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", ...) {
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
    
    make_pb <- function(..., label = NULL) {
      if (!is.null(pb)) return(pb)
      label <- paste0(label, "")
      pb <<- winProgressBar(..., label = label)
      pb
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        make_pb(max = config$max_steps, label = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        make_pb(max = config$max_steps, label = state$message)
        setWinProgressBar(pb, value = state$step, label = paste0(state$message, ""))
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        if (!state$enabled) return()
        if (config$clear) {
          close(pb)
          pb <<- NULL
        } else {
          setWinProgressBar(pb, value = state$step, label = paste0(state$message, ""))
        }
      }
    )
  })
  
  make_progression_handler("winprogressbar", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [pbmcapply::progressBar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param substyle (integer) The progress-bar substyle according to [pbmcapply::progressBar()].
#'
#' @param style (character) The progress-bar style according to [pbmcapply::progressBar()].
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/pbmcapply_handler.R
#'
#' @importFrom utils file_test flush.console txtProgressBar setTxtProgressBar
#' @export
pbmcapply_handler <- function(substyle = 3L, style = "ETA", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  if (!is_fake("pbmcapply_handler")) {
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
        flush.console()
      })
    }
  } else {
    progressBar <- function(..., style, substyle) txtProgressBar(..., style = substyle)
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
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
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
  
  make_progression_handler("pbmcapply", reporter, intrusiveness = intrusiveness, ...)
}



#' Visual Progression Feedback
#'
#' A progression handler for [progress::progress_bar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param format (character string) The format of the progress bar.
#'
#' @param show_after (numeric) Number of seconds to wait before displaying
#' the progress bar.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/progress_handler.R
#'
#' @export
progress_handler <- function(format = "[:bar] :percent :message", show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
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
        tokens <- list(message = paste0(state$message, ""))
        pb$tick(0, tokens = tokens)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (state$delta >= 0) {
          make_pb(format = format, total = config$max_steps,
                  clear = config$clear, show_after = config$enable_after)
          tokens <- list(message = paste0(state$message, ""))
          pb$tick(state$delta, tokens = tokens)
        }
      },
        
      finish = function(config, state, progression, ...) {
        if (is.null(pb) || pb$finished) return()
        make_pb(format = format, total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        reporter$update(config = config, state = state, progression = progression, ...)
        if (config$clear && !pb$finished) pb$update(1.0)
      }
    )
  })

  make_progression_handler("progress", reporter, intrusiveness = intrusiveness, ...)
}



#' Auditory Progression Feedback
#'
#' A progression handler for [beepr::beep()].
#'
#' @inheritParams make_progression_handler
#'
#' @param initiate,update,finish (integer) Indices of [beepr::beep()] sounds to
#'  play when progress starts, is updated, and completes.  For silence, use `NA_integer_`.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/beepr_handler.R
#'
#' @export
beepr_handler <- function(initiate = 2L, update = 10L,  finish = 11L, intrusiveness = getOption("progressr.intrusiveness.auditory", 5.0), target = "audio", ...) {
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
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        beep(update)
      },
        
      finish = function(config, state, progression, ...) {
        if (!state$enabled) return()
        beep(finish)
      }
    )
  })
  
  make_progression_handler("beepr", reporter, intrusiveness = intrusiveness, ...)
}



#' Operating-System Specific Progression Feedback
#'
#' A progression handler for [notifier::notify()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/notifier_handler.R
#'
#' @export
notifier_handler <- function(intrusiveness = getOption("progressr.intrusiveness.notifier", 10), target = "gui", ...) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("notifier_handler")) {
    notifier_notify <- function(...) notifier::notify(...)
  } else {
    notifier_notify <- function(...) NULL
  }

  notify <- function(step, max_steps, message) {
    ratio <- sprintf("%.0f%%", 100*step/max_steps)
    msg <- paste(c("", message), collapse = "")
    notifier_notify(sprintf("[%s] %s", ratio, msg))
  }

  reporter <- local({
    finished <- FALSE
    
    list(
      reset = function(...) {
        finished <<- FALSE
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        if (finished) return()
        if (!state$enabled) return()
        if (state$delta > 0) notify(step = state$step, max_steps = config$max_steps, message = state$message)
	finished <<- TRUE
      }
    )
  })
  
  make_progression_handler("notifier", reporter, intrusiveness = intrusiveness, ...)
}




#' Textual Progression Feedback for Debug Purposes
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/debug_handler.R
#'
#' @export
debug_handler <- function(interval = getOption("progressr.interval", 0), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", ...) {
  reporter <- local({
    t_init <- NULL
    
    add_to_log <- function(config, state, progression, ...) {
      t <- Sys.time()
      if (is.null(t_init)) t_init <<- t
      dt <- difftime(t, t_init, units = "secs")
      delay <- difftime(t, progression$time, units = "secs")
      message <- paste(c(state$message, ""), collapse = "")
      entry <- list(now(t), dt, delay, progression$type, state$step, config$max_steps, state$delta, message, config$clear, state$enabled, paste0(progression$status, ""))
      msg <- do.call(sprintf, args = c(list("%s(%.3fs => +%.3fs) %s: %d/%d (%+d) '%s' {clear=%s, enabled=%s, status=%s}"), entry))
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
  
  make_progression_handler("debug", reporter, intrusiveness = intrusiveness, ...)
}



#' Textual Progression Feedback that outputs a Newline
#'
#' @inheritParams make_progression_handler
#'
#' @param symbol (character string) The character symbol to be outputted,
#' which by default is the ASCII NL character (`'\n'` = `'\013'`) character.
#'
#' @param file (connection) A [base::connection] to where output should be sent.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @export
newline_handler <- function(symbol = "\n", file = stderr(), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", ...) {
  reporter <- local({
    list(
      initiate = function(...) cat(file = file, symbol),
      update   = function(...) cat(file = file, symbol),
      finish   = function(...) cat(file = file, symbol)
    )
  })
  
  make_progression_handler("newline", reporter, intrusiveness = intrusiveness, ...)
}




#' Progression Updates Reflected as the Size of a File
#'
#' @inheritParams make_progression_handler
#'
#' @param file (character) A filename.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(filesize_handler(file = "myscript.progress"))
#' with_progress(y <- slow_sum(1:100))
#' }}
#'
#' @importFrom utils file_test
#' @export
filesize_handler <- function(file = "default.progress", intrusiveness = getOption("progressr.intrusiveness.file", 5), target = "file", ...) {
  reporter <- local({
    set_file_size <- function(config, state, progression) {
      ratio <- state$step / config$max_steps
      size <- round(100 * ratio)
      current_size <- file.size(file)
      if (is.na(current_size)) file.create(file, showWarnings = FALSE)
      if (size == 0L) return()
      if (progression$amount == 0) return()          

      head <- sprintf("%g/%g: ", state$step, config$max_steps)
      nhead <- nchar(head)
      tail <- sprintf(" [%d%%]", round(100 * ratio))
      ntail <- nchar(tail)
      mid <- paste0(state$message, "")
      nmid <- nchar(mid)
      padding <- size - (nhead + nmid + ntail)
      if (padding <= 0) {
        msg <- paste(head, mid, tail, sep = "")
        if (padding < 0) msg <- substring(msg, first = 1L, last = size)
      } else if (padding > 0) {
        mid <- paste(c(mid, " ", rep(".", times = padding - 1L)), collapse = "")
        msg <- paste(head, mid, tail, sep = "")
      }
      
      cat(file = file, append = FALSE, msg)
    }
    
    list(
      initiate = function(config, state, progression, ...) {
        set_file_size(config = config, state = state, progression = progression)
      },
      
      update = function(config, state, progression, ...) {
        set_file_size(config = config, state = state, progression = progression)
      },
      
      finish = function(config, state, progression, ...) {
        if (config$clear) {
	  if (file_test("-f", file)) file.remove(file)
	} else {
          set_file_size(config = config, state = state, progression = progression)
	}
      }
    )
  })
  
  make_progression_handler("filesize", reporter, intrusiveness = intrusiveness, ...)
}


#' Visual Progression Feedback
#'
#' A progression handler for \pkg{shiny} and [shiny::withProgress()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(shiny_handler())
#' with_progress(y <- slow_sum(1:100))
#' }}
#'
#' @export
shiny_handler <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", ...) {
  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        shiny::incProgress(amount = progression$amount / config$max_steps,
	                   message = state$message)
      }
    )
  })
  
  make_progression_handler("shiny", reporter, intrusiveness = intrusiveness, ...)
}
