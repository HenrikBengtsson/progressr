#' Progression Handler: Progress Reported via 'shiny' Widgets (GUI) in the HTML Browser
#'
#' A progression handler for \pkg{shiny} and [shiny::withProgress()].
#'
#' @inheritParams make_progression_handler
#'
#' @param map Specifies whether the progression message should be mapped
#' to the 'message' and 'detail' element in the Shiny progress panel.
#' This argument should be a named character string with value `"message"`
#' or `"detail"` and where the name should be `message`, e.g.
#' `map = c(message = "message")` or `map = c(message = "detail")`.
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
handler_shiny <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", map = c(message = "message"), ...) {
  stop_if_not(
    is.character(map), all(map %in% c("message", "detail")),
    !is.null(names(map)), all(names(map) %in% c("message"))
  )

  ## Default: The progression message updates Shiny 'message'
  map_args <- function(state) list(message = state$message)

  ## Should progress message update another Shiny field?
  if ("message" %in% names(map)) {
    if (map["message"] == "detail") {
     map_args <- function(state) list(detail = state$message)
    }
  }

  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        amount <- if (config$max_steps == 0) 1 else progression$amount / config$max_steps
        args <- c(list(amount = amount), map_args(state))
        do.call(shiny::incProgress, args = args)
      }
    )
  })
  
  make_progression_handler("shiny", reporter, intrusiveness = intrusiveness, target = target, ...)
}
