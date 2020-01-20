#' Progressr Progression Updates in Plyr
#'
#' A \pkg{plyr} "progress bar" that signals [progression] conditions.
#'
#' @param \ldots Not used.
#'
#' @return A named [base::list] that can be passed as argument `.progress`
#' to any of \pkg{plyr} function accepting that argument.
#'
#' @examples
#' with_progress({
#'   y <- plyr::l_ply(1:10, function(...) Sys.sleep(0.1), .progress = "progressr")
#' })
#'
#' @export
progress_progressr <- function(...) {
  ## Progressor
  progress <- NULL

  ## List of plyr-recognized progress functions
  list(
    init = function(x, ...) {
      progress <<- progressor(x)
    },
    
    step = function() {
      progress()
    },
    
    term = function() NULL
  )
}
