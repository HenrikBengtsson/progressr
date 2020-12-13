#' Progression Handler: Progress Reported in the RStudio Console
#'
#' @inheritParams make_progression_handler 
#'
#' @param title (character or a function) The "name" of the progressor, which
#' is displayed in front of the progress bar.  If a function, then the name
#' is created dynamically by calling the function when the progressor is
#' created.
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
handler_rstudio <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", title = function() format(Sys.time(), "Console %X"), ...) {
  reporter <- local({
    job_id <- NULL
    list(
      initiate = function(config, state, ...) {
        if (!state$enabled || config$times <= 2L) return()
        name <- state$message
        if (length(name) == 0L) {
          if (is.null(title)) {
            name <- "Console"
          } else if (is.character(title)) {
            name <- title
          } else if (is.function(title)) {
            name <- title()
          }
        }
        stop_if_not(
          is.null(job_id),
          is.character(name),
          length(name) == 1L
        )
        job_id <<- rstudioapi::jobAdd(
          name          = name,
          progressUnits = as.integer(config$max_steps),
          status        = "running",
          autoRemove    = FALSE,
          show          = FALSE
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
