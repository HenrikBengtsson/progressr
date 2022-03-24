#' Aggregate Progression Conditions
#'
#' @param progress A [progressor] function.
#'
#' @return A function of class `progress_aggregator`.
#'
#' @example incl/progress_aggregator.R
#'
#' @keywords internal
#' @export
progress_aggregator <- function(progress) {
  stop_if_not(inherits(progress, "progressor"))

  ## Here we can find out how many steps the progressor function wants
  max_steps <- environment(progress)$steps
  
  handler <- function(p) {
    stop_if_not(inherits(p, "progression"))
    type <- p$type
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("Progression handler %s ...", sQuote(type))
      on.exit(mprintf("Progression handler %s ... done", sQuote(type)))
      mprintf("- progression:")
      mstr(p)
      mprintf("- progressor_uuid: %s", p$progressor_uuid)
      mprintf("- progression_index: %d", p$progression_index)
    }
    if (type == "initiate") {
    } else if (type == "finish") {
    } else if (type == "reset") {
    } else if (type == "shutdown") {
    } else if (type == "update") {
      progress(child = p)
    } else {
      ## Was this meant to be a 'control_progression' condition?
      if (type %in% c("reset", "shutdown", "hide", "unhide", "interrupt")) {
        stop("Unsupported 'progression' type. Was it meant to be a 'control_progression' condition?: ", sQuote(type))
      } else {
        stop("Unknown 'progression' type: ", sQuote(type))
      }
    }
    
    ## Prevent upstream calling handlers to receive progression 'p'
    invokeRestart("muffleProgression")
  }

  handler <- make_progression_handler("progress_aggregator", handler = handler)
  
  fcn <- function(...) {
    with_progress(..., handlers = handler)
  }
  class(fcn) <- c("progress_aggregator", class(fcn))

  fcn
}
