#' Use Progressr with Plyr Map-Reduce Functions
#'
#' A "progress bar" for \pkg{plyr}'s `.progress` argument.
#'
#' @param \ldots Not used.
#'
#' @return A named [base::list] that can be passed as argument `.progress`
#' to any of \pkg{plyr} function accepting that argument.
#'
#' @example incl/plyr_progress_progressr.R
#'
#' @section Limitations:
#' One can use use [doFuture::registerDoFuture()] to run \pkg{plyr} functions
#' in parallel, e.g. `plyr::l_ply(..., .parallel = TRUE)`.  Unfortunately,
#' using `.parallel = TRUE` disables progress updates because, internally,
#' \pkg{plyr} forces `.progress = "none"` whenever `.parallel = TRUE`.
#' Thus, despite the \pkg{future} ecosystem and \pkg{progressr} would support
#' it, it is not possible to run \pkg{dplyr} in parallel _and_ get progress
#' updates at the same time.
#'
#' @export
progress_progressr <- function(...) {
  ## Progressor
  p <- NULL

  ## List of plyr-recognized progress functions
  list(
    init = function(x, ...) {
      p <<- progressor(x)
    },
    
    step = function() {
      p()
    },
    
    term = function() NULL
  )
}
