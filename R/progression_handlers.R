#' Auditory Progression Feedback
#'
#' @export
ascii_alert_handler <- function(symbol = "\a", ..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), file = stderr(), enable = interactive()) {
  if (!enable) times <- 0

  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    list(
      setup = function() {
      },
      
      update = function(delta) {
        cat(file = file, symbol)
      },
      
      done = function(delta) {
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("ascii_alert", handler, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
txtprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), file = stderr()) {
  ## Import functions
  txtProgressBar <- utils::txtProgressBar
  getTxtProgressBar <- utils::getTxtProgressBar
  setTxtProgressBar <- utils::setTxtProgressBar

  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    pb <- NULL
    
    list(
      setup = function() {
        pb <<- txtProgressBar(max = max_steps, ..., file = file)
      },
      
      update = function(delta) {
        setTxtProgressBar(pb, value = step)
      },
      
      done = function(delta) {
        close(pb)
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("txtprogressbar", handler, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
tkprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), enable = interactive()) {
  ## Import functions
  tkProgressBar <- tcltk::tkProgressBar
  getTkProgressBar <- tcltk::getTkProgressBar
  setTkProgressBar <- tcltk::setTkProgressBar

  if (!enable) times <- 0

  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    pb <- NULL
    
    list(
      setup = function() {
        pb <<- tkProgressBar(max = max_steps, ...)
      },
      
      update = function(delta) {
        setTkProgressBar(pb, value = step)
      },
      
      done = function(delta) {
        close(pb)
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("tkprogressbar", handler, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
progress_handler <- function(..., clear = FALSE, show_after = 0, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  ## Import functions
  progress_bar <- progress::progress_bar

  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    pb <- NULL
    
    list(
      setup = function() {
        pb <<- progress_bar$new(total = max_steps,
	                        clear = clear, show_after = show_after, ...)
        pb$tick(0)
      },
      
      update = function(delta) {
        if (delta > 0) pb$tick(delta)
      },
      
      done = function(delta) {
        if (delta > 0) pb$tick(delta)
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("progress", handler, times = times, interval = interval)
}



#' Auditory Progression Feedback
#'
#' @export
beepr_handler <- function(setup = 2L, update = 10L,  done = 11L, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), enable = interactive(), ...) {
  ## Import functions
  beep <- beepr::beep
  
  if (!enable) times <- 0
  
  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    list(
      setup = function() {
        beep(setup)
      },
      
      update = function(delta) {
        beep(update)
      },
      
      done = function(delta) {
        beep(done)
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("beepr", handler, times = times, interval = interval)
}



#' Operating-System Specific Progression Feedback
#'
#' @export
notifier_handler <- function(setup = 2L, update = 10L,  done = 11L, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 5), enable = interactive(), ...) {
  if (!enable) times <- 0
  
  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  ## Reporter state
  reporter <- local({
    notify_ideally <- function(p) {
      msg <- paste(c("", p$message), collapse = "")
      ratio <- switch(p$type, setup = "STARTED", done = "DONE", sprintf("%.0f%%", 100*step/max))
      notifier::notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
    }

    notify <- function(step) {
      notifier::notify(sprintf("[%.1f%%] Step %d of %d", 100*step/max_steps, step, max_steps))
    }

    list(
      setup = function() {
        notify(step)
      },
      
      update = function(delta) {
        notify(step)
      },
      
      done = function(delta) {
        notify(step)
      }
    )
  })
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max_steps <<- p$steps
      times <- min(times, max_steps)
      milestones <<- seq(from = 1L, to = max_steps, length.out = times)
      step <<- 0L
      reporter$setup()
      prev_milestone <<- step
      milestones <<- milestones[-1]
      prev_milestone_time <<- Sys.time()
    } else if (type == "done") {
      reporter$done(max_steps - prev_milestone)
      prev_milestone <<- max_steps
      prev_milestone_time <<- Sys.time()
    } else if (type == "update") {
      step <<- step + p$amount
      if (length(milestones) > 0L && step >= milestones[1]) {
        skip <- FALSE
        if (interval > 0) {
	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
          skip <- (dt < interval)
        }
	if (!skip) {
          reporter$update(step - prev_milestone)
          milestones <<- milestones[-1]
          prev_milestone <<- step
          prev_milestone_time <<- Sys.time()
	}
      }
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }

  progression_handler("notifier", handler, times = times, interval = interval)
}
