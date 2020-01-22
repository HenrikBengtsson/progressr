#' Progression Handler: Progress Reported via 'shiny' Widgets (GUI) in the HTML Browser
#'
#' A progression handler for \pkg{shiny} and [shiny::withProgress()].
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(handler_shiny())
#' with_progress(y <- slow_sum(1:100))
#' }}
#'
#' @section Requirements:
#' This progression handler requires the \pkg{shiny} package.
#'
#' @details
#' For most Shiny application there is little need to use this Shiny handler
#' directly.  Instead, it is sufficient to use [withProgressShiny()].
#'
#' @keywords internal
#' @export
handler_shiny <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", ...) {
  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        shiny::incProgress(amount = progression$amount / config$max_steps,
	                   message = state$message)
      }
    )
  })
  
  make_progression_handler("shiny", reporter, intrusiveness = intrusiveness, ...)
}
