#' @export
txtprogressbar_handler <- function(..., file = stderr()) {
  pb <- NULL

  ## Import functions
  txtProgressBar <- utils::txtProgressBar
  getTxtProgressBar <- utils::getTxtProgressBar
  setTxtProgressBar <- utils::setTxtProgressBar
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      pb <<- txtProgressBar(max = p$steps, ..., file = file)
    } else if (type == "done") {
      close(pb)
    } else if (type == "update") {
      setTxtProgressBar(pb, value = getTxtProgressBar(pb) + p$amount)
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}


#' @export
progress_handler <- function(...) {
  pb <- NULL

  ## Import functions
  progress_bar <- progress::progress_bar
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      pb <<- progress_bar$new(total = p$steps, ...)
    } else if (type == "done") {
    } else if (type == "update") {
      pb$tick(len = p$amount)
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}



#' @export
beepr_handler <- function(setup = 2L, update = 10L,  done = 11L, enable = interactive(), ...) {
  pb <- NULL

  ## Import functions
  if (enable) {
    beep <- beepr::beep
  } else {
    beep <- function(...) NULL
  }
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      beep(setup)
    } else if (type == "done") {
      beep(done)
    } else if (type == "update") {
      beep(update)
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }
  }
  class(handler) <- c("progression_handler", class(handler))
  handler
}
