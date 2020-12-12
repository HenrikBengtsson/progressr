#' Progression Handler: Progress Reported in the RStudio Console
#'
#' @inheritParams make_progression_handler 
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler works only in the RStudio Console.
#'
#' @section Use this progression handler by default:
#' To use this handler by default whenever using the RStudio Console, add
#' the following to your \file{~/.Rprofile} startup file:
#'
#' ```r
#' if (requireNamespace("progressr", quietly = TRUE)) {
#'   if (Sys.getenv("RSTUDIO") == "1" && !nzchar(Sys.getenv("RSTUDIO_TERM"))) {
#'     options(progressr.handlers = progressr::handler_rstudio)
#'   }
#' }
#' ```
#'
#' @example incl/handler_rstudio.R
#'
#' @export
handler_rstudio <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", ...) {
  reporter <- local({
    job_id <- NULL
    list(
      initiate = function(config, state, ...) {
        if (!state$enabled || config$times <= 2L) return()
        title <- state$message
        if (length(title) == 0L) title <- "Console"
        stop_if_not(is.null(job_id))
        job_id <<- rstudioapi::jobAdd(
          name = title,
          progressUnits = as.integer(config$max_steps),
          status = "running",
          autoRemove = FALSE,
          show = FALSE
        )
      },
      
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        ## The RStudio Job progress bar cannot go backwards
        if (state$delta < 0) return()
        ## The RStudio Job progress bar does not have a "spinner"
        if (state$delta == 0) return()
        stop_if_not(!is.null(job_id))
        rstudioapi::jobSetProgress(job_id, units = state$step)
      },

      finish = function(...) {
        if (!is.null(job_id)) rstudioapi::jobRemove(job_id)
        job_id <<- NULL
      }
    )
  })

  make_progression_handler("rstudio", reporter, intrusiveness = intrusiveness, target = target, ...)
}
