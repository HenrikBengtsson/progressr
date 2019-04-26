#' Aggregate Progression Conditions
#'
#' @param progress A [progressor] function.
#'
#' @return A function of class `progress_aggregator`.
#'
#' @example incl/progress_aggregator.R
#'
#' @export
progress_aggregator <- function(progress) {
  stop_if_not(inherits(progress, "progressor"))

  ## Here we can find out how many steps the progressor function wants
  steps <- environment(progress)$steps

  max <- NULL
  
  handler <- function(p) {
    stopifnot(inherits(p, "progression"))
    type <- p$type
    if (type == "setup") {
      max <<- p$steps
    } else if (type == "done") {
      progress()
    } else if (type == "update") {
      ## FIXME: Identify 'substeps' ("weights per step") and
      ## relay relative to 'max'
    } else {
      warning("Unknown 'progression' type: ", sQuote(type))
    }

    ## Prevent upstream calling handlers to receive progression 'p'
    invokeRestart("consume_progression")
  }
  
  handler <- progression_handler("progress_aggregator", handler)
  
  fcn <- function(...) {
    with_progress(..., handlers = handler)
  }
  class(fcn) <- c("progress_aggregator", class(fcn))

  fcn
}
