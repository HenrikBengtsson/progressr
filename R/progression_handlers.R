#' @export
ascii_alert_handler <- function(symbol = "\a", ..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), file = stderr(), enable = interactive()) {
  pb <- NULL
  
  if (!enable) times <- 0
  if (times > 0) {
    at <- NULL
    step <- 0L
    t0 <- Sys.time()
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = max, length.out = times)
	}
      } else if (type == "done") {
      } else if (type == "update") {
        step <<- step + p$amount
##        str(list(type = type, step = step, at = at, times = times))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          if (!skip) cat(file = file, symbol)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("ascii_alert", handler)
}



#' @export
txtprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), file = stderr()) {
  pb <- NULL

  ## Import functions
  txtProgressBar <- utils::txtProgressBar
  getTxtProgressBar <- utils::getTxtProgressBar
  setTxtProgressBar <- utils::setTxtProgressBar

  if (times >= 1L) {
    at <- NULL
    step <- 0L
    t0 <- Sys.time()
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
	pb <<- txtProgressBar(max = p$steps, ..., file = file)
      } else if (type == "done") {
        close(pb)
      } else if (type == "update") {
        step <<- step + p$amount
#        str(list(type = type, step = step, at = at))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          if (!skip) setTxtProgressBar(pb, value = step)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("txtprogressbar", handler)
}



#' @export
tkprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), enable = interactive()) {
  pb <- NULL

  if (!enable) times <- 0
  if (times > 0) {
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    at <- NULL
    step <- 0L
    t0 <- Sys.time()

    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        pb <<- tkProgressBar(max = p$steps, ...)
        if (interval > 0) t0 <<- Sys.time()
#        str(list(type = type, step = step, at = at))
      } else if (type == "done") {
        close(pb)
      } else if (type == "update") {
        step <<- step + p$amount
#        str(list(type = type, step = step, at = at))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          if (!skip) setTkProgressBar(pb, value = step)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("tkprogressbar", handler)
}



#' @export
progress_handler <- function(..., clear = FALSE, show_after = 0, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  pb <- NULL

  ## Import functions
  progress_bar <- progress::progress_bar
  
  if (times > 0) {
    at <- NULL
    step <- 0L
    t0 <- Sys.time()
    delta <- 1L
    max <- NULL
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <<- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	  delta <<- p$steps / times
	}
        pb <<- progress_bar$new(total = max, clear = clear, show_after = show_after, ...)
        if (is.finite(times)) {
          if (interval > 0) t0 <<- Sys.time()
	  pb$tick(0)
	}
	at <<- at[-1]
      } else if (type == "done") {
        ## May give an error, e.g. times = 1L
        if (is.finite(times)) {
          tryCatch(pb$tick(delta), error = identity)
	}
      } else if (type == "update") {
        step <<- step + p$amount
#        str(list(type = type, step = step, at = at, delta = delta))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          pb$tick(delta)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("progress", handler)
}



#' @export
beepr_handler <- function(setup = 2L, update = 10L,  done = 11L, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), enable = interactive(), ...) {
  pb <- NULL
  
  if (!enable) times <- 0
  if (times > 0L) {
    ## Import functions
    beep <- beepr::beep
    
    at <- NULL
    step <- 0L
    t0 <- Sys.time()
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        if (times > 1) {
          if (interval > 0) t0 <<- Sys.time()
	  beep(setup)
	}
      } else if (type == "done") {
        beep(done)
      } else if (type == "update") {
        step <<- step + p$amount
#        str(list(type = type, step = step, at = at))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          if (!skip) beep(update)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("beepr", handler)
}



#' @export
notifier_handler <- function(setup = 2L, update = 10L,  done = 11L, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 5), enable = interactive(), ...) {
  pb <- NULL
  
  if (!enable) times <- 0
  if (times > 0L) {  
    at <- NULL
    step <- 0L
    max <- 0L
    t0 <- Sys.time()

    notify <- function(p) {
      msg <- paste(c("", p$message), collapse = "")
      ratio <- switch(p$type, setup = "STARTED", done = "DONE", sprintf("%.0f%%", 100*step/max))
      notifier::notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
    }
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max <<- p$steps
        if (is.finite(times) && times >= max) times <- +Inf
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        if (times > 1) {
          if (interval > 0) t0 <<- Sys.time()
          notify(p)
	}
      } else if (type == "done") {
        notify(p)
      } else if (type == "update") {
        step <<- step + p$amount
#        str(list(type = type, step = step, at = at))
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
	  skip <- FALSE
          if (is.infinite(times) || (length(at) > 0L && interval > 0)) {
	    t <- Sys.time()
	    if (difftime(t, t0, units = "secs") > interval) {
	      t0 <<- t
	    } else {
              skip <- TRUE
	    }
	  }
          if (!skip) notify(p)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
      times <<- times - 1
    }
  } else {
    handler <- function(p) NULL
  }

  progression_handler("notifier", handler)
}
