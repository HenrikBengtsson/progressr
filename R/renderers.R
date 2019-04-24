#' @export
renderer_txtprogressbar <- function(..., file = stderr()) {
  pb <- NULL

  ## Import functions
  txtProgressBar <- utils::txtProgressBar
  getTxtProgressBar <- utils::getTxtProgressBar
  setTxtProgressBar <- utils::setTxtProgressBar
  
  renderer <- function(p) {
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
  class(renderer) <- c("progression_renderer", class(renderer))
  renderer
}


#' @export
renderer_progress <- function(...) {
  pb <- NULL

  ## Import functions
  progress_bar <- progress::progress_bar
  
  renderer <- function(p) {
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
  class(renderer) <- c("progression_renderer", class(renderer))
  renderer
}
