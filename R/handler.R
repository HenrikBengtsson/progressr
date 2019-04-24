#' @export
ascii_alert_handler <- function(symbol = "\a", ..., times = getOption("progressr.times", +Inf), file = stderr(), enable = interactive()) {
  pb <- NULL
  
  if (!enable) times <- 0
  if (times > 0) {
    at <- NULL
    step <- 0L
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      times <<- times - 1
      type <- p$type
      if (type == "setup") {
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        if (times >= 1) cat(file = file, symbol)
      } else if (type == "done") {
        cat(file = file, symbol)
      } else if (type == "update") {
        step <<- step + p$amount
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
          cat(file = file, symbol)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
    }
  } else {
    handler <- function(p) NULL
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}


#' @export
txtprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), file = stderr()) {
  pb <- NULL

  ## Import functions
  txtProgressBar <- utils::txtProgressBar
  getTxtProgressBar <- utils::getTxtProgressBar
  setTxtProgressBar <- utils::setTxtProgressBar

  if (times >= 1L) {
    at <- NULL
    step <- 0L
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      times <<- times - 1L
      type <- p$type
      if (type == "setup") {
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
	pb <<- txtProgressBar(max = p$steps, ..., file = file)
      } else if (type == "done") {
        close(pb)
      } else if (type == "update") {
        step <<- step + p$amount
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
          setTxtProgressBar(pb, value = step)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
    }
  } else {
    handler <- function(p) NULL
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}



#' @export
tkprogressbar_handler <- function(..., times = getOption("progressr.times", +Inf), enable = interactive()) {
  pb <- NULL

  if (!enable) times <- 0
  if (times > 0) {
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    at <- NULL
    step <- 0L

    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      times <<- times - 1
      type <- p$type
      if (type == "setup") {
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        pb <<- tkProgressBar(max = p$steps, ...)
      } else if (type == "done") {
        close(pb)
      } else if (type == "update") {
        step <<- step + p$amount
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
          setTkProgressBar(pb, value = step)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
    }
  } else {
    handler <- function(p) NULL
  }

  class(handler) <- c("progression_handler", class(handler))
  handler
}



#' @export
progress_handler <- function(..., times = getOption("progressr.times", +Inf)) {
  pb <- NULL

  ## Import functions
  progress_bar <- progress::progress_bar
  
  if (times > 0) {
    at <- NULL
    step <- 0L
    max <- NULL
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      times <<- times - 1
      type <- p$type
      if (type == "setup") {
        max <<- p$steps
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = max, length.out = times)
	}
        pb <<- progress_bar$new(total = max, ...)
      } else if (type == "done") {
      } else if (type == "update") {
        step <<- step + p$amount
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
          pb$update(ratio = step/max)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
    }
  } else {
    handler <- function(p) NULL
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}



#' @export
beepr_handler <- function(setup = 2L, update = 10L,  done = 11L, times = getOption("progressr.times", +Inf), enable = interactive(), ...) {
  pb <- NULL
  
  if (!enable) times <- 0
  if (times > 0L) {
    ## Import functions
    beep <- beepr::beep
    
    at <- NULL
    step <- 0L
    
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      times <<- times - 1
      type <- p$type
      if (type == "setup") {
        if (is.finite(times)) {
	  at <<- seq(from = 1L, to = p$steps, length.out = times)
	}
        if (times >= 1) beep(setup)
      } else if (type == "done") {
        beep(done)
      } else if (type == "update") {
        step <<- step + p$amount
        if (is.infinite(times) || step >= at[1]) {
	  at <<- at[-1]
          beep(update)
	}
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }
    }
  } else {
    handler <- function(p) NULL
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}
