#' Use Progressr in Shiny Apps: Plug-in Backward Compatibility Replacement for shiny::withProgress()
#'
#' @inheritParams handler_shiny
#'
#' @param expr,\ldots,env,quoted Arguments passed to [shiny::withProgress] as is.
#'
#' @param message,detail (character string) The message and the detail message to be passed to [shiny::withProgress()].
#' 
#' @param handlers Zero or more progression handlers used to report on progress.
#'
#' @return The value of [shiny::withProgress].
#'
#' @example incl/withProgressShiny.R
#'
#' @section Requirements:
#' This function requires the \pkg{shiny} package and will use the
#' [handler_shiny()] **progressr** handler internally to report on updates.
#'
#' @export
withProgressShiny <- function(expr, ..., message = NULL, detail = NULL, map = c(message = "message"), env = parent.frame(), quoted = FALSE, handlers = c(shiny = handler_shiny, progressr::handlers(default = NULL))) {
  if (!quoted) expr <- substitute(expr)

  stop_if_not("shiny" %in% names(handlers))
  if (sum(names(handlers) == "shiny") > 1) {
    warning("Detected a 'shiny' handler set via progressr::handlers()")
  }

  stop_if_not(
    is.character(map), all(map %in% c("message", "detail")),
    !is.null(names(map)), all(names(map) %in% c("message"))
  )

  ## Customize the shiny 'message' target?
  if (is.function(handlers$shiny) &&
      !inherits(handlers$shiny, "progression_handler")) {
    tweaked_handler_shiny <- handlers$shiny
    if (!identical(map, formals(tweaked_handler_shiny)$map)) {
      formals(tweaked_handler_shiny)$map <- map
      handlers$shiny <- tweaked_handler_shiny
    }
  }
  
  expr <- bquote(progressr::with_progress({.(expr)}, handlers = .(handlers)))
  res <- withVisible(shiny::withProgress(expr, ..., message = message, detail = detail, env = env, quoted = TRUE))
  if (res$visible) res$value else invisible(res$value)
}
