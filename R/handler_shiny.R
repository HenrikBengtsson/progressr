#' Progression Handler: Progress Reported via 'shiny' Widgets (GUI) in the HTML Browser
#'
#' A progression handler for \pkg{shiny} and [shiny::withProgress()].
#'
#' @inheritParams make_progression_handler
#'
#' @param inputs (named list) Specifies from what sources the Shiny progress
#' elements 'message' and 'detail' should be updated.  Valid sources are
#' `"message"`, `"sticky_message"` and `"non_sticky_message"`, where
#' `"message"` is short for `c("non_sticky_message", "sticky_message")`. For
#' example, `inputs = list(message = "sticky-message", detail = "message")`
#' will update the Shiny 'message' component from sticky messages only,
#' whereas the 'detail' component is updated using any message.
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
handler_shiny <- function(intrusiveness = getOption("progressr.intrusiveness.gui", 1), target = "gui", inputs = list(message = NULL, detail = "message"), ...) {
  stop_if_not(
    is.list(inputs),
    !is.null(names(inputs)),
    all(names(inputs) %in% c("message", "detail")),
    all(vapply(inputs, FUN = function(x) {
      if (is.null(x)) return(TRUE)
      if (!is.character(x)) return(FALSE)
      x %in% c("message", "non_sticky_message", "sticky_message")
    }, FUN.VALUE = FALSE))
  )

  ## Expand 'message' => c("non_sticky_message", "sticky_message")
  for (name in names(inputs)) {
    input <- inputs[[name]]
    if ("message" %in% input) {
      input <- setdiff(input, "message")
      input <- c(input, "non_sticky_message", "sticky_message")
    }
    inputs[[name]] <- unique(input)
  }
  
  ## Default: The progression message updates Shiny 'message'
  map_args <- function(state, progression) {
    message <- progression$message
    if (is.null(message)) return(list())

    ## Update Shiny 'message' and 'detail'?
    args <- list()
    for (target in c("message", "detail")) {
      if (inherits(progression, "sticky")) {
        if ("sticky_message" %in% inputs[[target]])
          args[[target]] <- message
      } else {
        if ("non_sticky_message" %in% inputs[[target]])
          args[[target]] <- message
      }
    }

    args
  }

  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        amount <- if (config$max_steps == 0) 1 else progression$amount / config$max_steps
        args <- c(list(amount = amount), map_args(state, progression))
        do.call(shiny::incProgress, args = args)
      }
    )
  })
  
  make_progression_handler("shiny", reporter, intrusiveness = intrusiveness, target = target, ...)
}
